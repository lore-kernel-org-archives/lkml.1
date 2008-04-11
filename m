Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbYDKKWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbYDKKWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbYDKKWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:22:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35866 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873AbYDKKWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:22:31 -0400
Date: Fri, 11 Apr 2008 12:22:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, Ben Dooks <ben-linux@fluff.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.25
Message-ID: <20080411122206.373a7143@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem fixes for Linux 2.6.25 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 drivers/i2c/busses/i2c-davinci.c  |   17 ++++++-----------
 drivers/i2c/busses/i2c-ibm_iic.c  |    2 +-
 drivers/i2c/busses/i2c-tiny-usb.c |   12 ++++++++----
 3 files changed, 15 insertions(+), 16 deletions(-)

---------------

Paul Mundt (1):
      i2c-ibm_iic: Fast mode parm desc fixup

Till Harbaum (1):
      i2c-tiny-usb: New VID/PID pair

Troy Kisky (1):
      i2c-davinci: Fix lost interrupt

Thanks,
-- 
Jean Delvare
