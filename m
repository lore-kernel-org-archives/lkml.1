Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbXLLNNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbXLLNNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLLNNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:13:32 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:1857 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbXLLNNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:13:31 -0500
Date: Wed, 12 Dec 2007 14:13:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] more i2c fixes for 2.6.24
Message-ID: <20071212141328.552aeebb@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.24 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus


 Documentation/i2c/summary        |   45 +++----------------------------------
 drivers/i2c/busses/i2c-davinci.c |    4 +-
 drivers/i2c/busses/i2c-gpio.c    |    1 +
 drivers/i2c/busses/i2c-omap.c    |    6 ++--
 drivers/i2c/chips/isp1301_omap.c |    2 +-
 5 files changed, 11 insertions(+), 47 deletions(-)

---------------

Atsushi Nemoto (1):
      i2c-gpio: Initialize adapter class

David Brownell (1):
      i2c/isp1301_omap: Build fix

Jean Delvare (1):
      i2c: Delete an outdated piece of documentation

Joe Perches (1):
      i2c: Add missing spaces in split log messages


Thanks,
-- 
Jean Delvare
