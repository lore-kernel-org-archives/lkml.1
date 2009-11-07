Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbZKGNep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbZKGNep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 08:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZKGNem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 08:34:42 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59343 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbZKGNem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 08:34:42 -0500
Date: Sat, 7 Nov 2009 14:34:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.32
Message-ID: <20091107143444.44200912@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some more i2c subsystem fixes for Linux 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 Documentation/i2c/busses/i2c-piix4 |    2 +-
 drivers/i2c/busses/Kconfig         |    2 +-
 drivers/i2c/busses/i2c-piix4.c     |    8 ++++----
 drivers/net/sfc/sfe4001.c          |    4 ++--
 include/linux/i2c.h                |   18 ++++++++++++++++++
 include/linux/pci_ids.h            |    2 +-
 6 files changed, 27 insertions(+), 9 deletions(-)

---------------

Crane Cai (1):
      i2c-piix4: Modify code name SB900 to Hudson-2

Jean Delvare (1):
      i2c: Add an interface to lock/unlock an I2C bus segment

Thanks,
-- 
Jean Delvare
