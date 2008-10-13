Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYJMLf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYJMLf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYJMLfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:35:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40145 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756422AbYJMLfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:35:13 -0400
Date: Mon, 13 Oct 2008 12:35:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: WM8350 updates
Message-ID: <20081013113509.GA31973@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: But it does move!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1fbf1b714ea8ca685f024e91f0cfa83a40b8604f:
  Mark Brown (1):
        mfd: Add WM8350 subdevice registration helper

are available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-lrg

Mark Brown (2):
      mfd: Add placeholders for WM8350 client devices
      mfd: Fix warning in WM8350

 drivers/mfd/wm8350-core.c         |   21 ++++++++++++++++++++-
 include/linux/mfd/wm8350/audio.h  |    6 ++++++
 include/linux/mfd/wm8350/core.h   |   10 ++++++++++
 include/linux/mfd/wm8350/gpio.h   |    6 ++++++
 include/linux/mfd/wm8350/rtc.h    |    6 ++++++
 include/linux/mfd/wm8350/supply.h |    6 ++++++
 include/linux/mfd/wm8350/wdt.h    |    8 +++++++-
 7 files changed, 61 insertions(+), 2 deletions(-)
