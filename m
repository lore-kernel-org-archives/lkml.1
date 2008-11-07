Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYKGS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYKGS5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYKGS4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:56:47 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36794 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYKGS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:56:44 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 0/5] Various hwmon patches
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Fri, 07 Nov 2008 10:56:21 -0800
Message-ID: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are a myriad of hwmon patches that I've been working on.  Please have a
look and let me know what you think.

- New driver: adt7462
- Automatic loading for i5k-amb driver
- adt7470/adt7473: Check input values from sysfs
- lm85: Add adt7468 support

--D
