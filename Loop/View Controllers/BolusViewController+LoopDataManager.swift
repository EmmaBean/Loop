//
//  BolusViewController+LoopDataManager.swift
//  Loop
//
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

import UIKit
import HealthKit


extension BolusViewController {
    func configureWithLoopManager(_ manager: LoopDataManager, recommendation: BolusRecommendation?, glucoseUnit: HKUnit) {
        manager.getLoopState { (manager, state) in
            let maximumBolus = manager.settings.maximumBolus

            let activeCarbohydrates = state.carbsOnBoard?.quantity.doubleValue(for: .gram())
            let bolusRecommendation: BolusRecommendation?

            if let recommendation = recommendation {
                bolusRecommendation = recommendation
            } else {
                bolusRecommendation = try? state.recommendBolus()
            }

            manager.doseStore.insulinOnBoard(at: Date()) { (result) in
                let activeInsulin: Double?

                switch result {
                case .success(let value):
                    activeInsulin = value.value
                case .failure:
                    activeInsulin = nil
                }

                DispatchQueue.main.async {
                    if let maxBolus = maximumBolus {
                        self.maxBolus = maxBolus
                    }

                    self.glucoseUnit = glucoseUnit
                    self.activeInsulin = activeInsulin
                    self.activeCarbohydrates = activeCarbohydrates
                    self.bolusRecommendation = bolusRecommendation
                }
            }
        }
    }
}
