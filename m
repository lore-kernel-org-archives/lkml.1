Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXCVTTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXCVTTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXCVTTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:19:02 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:3078 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932943AbXCVTTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:19:00 -0400
Date: Thu, 22 Mar 2007 20:17:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <i2c@lm-sensors.org>
Subject: [GIT PULL] More i2c updates for 2.6.21
Message-Id: <20070322201722.0bc24d27.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.21 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus


 drivers/i2c/busses/i2c-amd8111.c |    3 ++-
 drivers/i2c/busses/i2c-i801.c    |   25 +++++++++++++++++++++++++
 drivers/i2c/chips/ds1374.c       |    4 ++++
 3 files changed, 31 insertions(+), 1 deletions(-)

---------------

Cyrill V. Gorcunov:
      i2c/ds1374: Check workqueue creation status

Jean Delvare:
      i2c-amd8111: Missed cleanup
      i2c-i801: Restore the device state before leaving

Thanks,
-- 
Jean Delvare
