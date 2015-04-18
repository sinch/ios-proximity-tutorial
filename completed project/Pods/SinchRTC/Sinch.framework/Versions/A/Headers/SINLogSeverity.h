/*
 * Copyright (c) 2015 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#ifndef SIN_LOG_SEVERITY_H
#define SIN_LOG_SEVERITY_H

typedef NS_ENUM(NSInteger, SINLogSeverity) {
  SINLogSeverityTrace = 0,
  SINLogSeverityInfo,
  SINLogSeverityWarn,
  SINLogSeverityCritical
};

#endif  // SIN_LOG_SEVERITY_H
