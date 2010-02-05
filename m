Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0BEQwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:52:04 -0500
Received: from poutre.nerim.net ([62.4.16.124]:51414 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab0BEQwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:52:01 -0500
Date: Fri, 5 Feb 2010 17:51:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: [GIT PULL] i2c fix for 2.6.33
Message-ID: <20100205175158.0ec9cc85@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one i2c subsystem fix for Linux 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/busses/i2c-tiny-usb.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

---------------

Jean Delvare (1):
      i2c-tiny-usb: Fix on big-endian systems

Thanks,
-- 
Jean Delvare
