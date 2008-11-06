Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYKFNnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYKFNnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYKFNm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:42:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60240 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753612AbYKFNmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:42:55 -0500
Date: Thu, 6 Nov 2008 13:42:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mfd: WM8350 updates
Message-ID: <20081106134254.GA21855@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: It's the thought, if any, that counts!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c3177623edf3fabf200c60bde9b400d03b6271f7:
  Mark Brown (1):
        mfd: Don't mark WM8350 security register as volatile

are available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-sameo

Mark Brown (4):
      mfd: Remove i.MX31ism from WM8350 i2c driver
      mfd: Add some documentation for WM8350 register lock
      mfd: Add WM8350 revision H support
      mfd: Add AUXADC support for WM8350

 drivers/mfd/wm8350-core.c             |   74 ++++++++++++++++++++++++++++++++-
 drivers/mfd/wm8350-i2c.c              |    2 -
 include/linux/mfd/wm8350/comparator.h |    8 ++++
 include/linux/mfd/wm8350/core.h       |    3 +
 4 files changed, 83 insertions(+), 4 deletions(-)
