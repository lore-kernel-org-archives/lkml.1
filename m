Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYH1H13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYH1H13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYH1H1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:27:21 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10040 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYH1H1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:27:21 -0400
Date: Thu, 28 Aug 2008 09:27:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.27
Message-ID: <20080828092701.3d6fe6e8@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.27 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus


 drivers/i2c/i2c-core.c |   18 ++++++++++--------
 include/linux/i2c.h    |   12 ++++++++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

---------------

Jean Delvare (2):
      i2c: Add missing kerneldoc descriptions
      i2c: Prevent log spam on some DVB adapters

Marc Pignat (1):
      i2c: Fix device_init_wakeup place

Thanks,
-- 
Jean Delvare
