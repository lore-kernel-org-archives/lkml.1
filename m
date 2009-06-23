Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZFWXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZFWXWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZFWXWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:22:13 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:47432 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752456AbZFWXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:22:13 -0400
Date: Wed, 24 Jun 2009 00:22:05 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: torvalds@linux-foundation.org, linux-i2c@vger.kernel.org,
       khali@linux-fr.org, apkm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Please pull bjdooks' i2c-next tree
Message-ID: <20090623232205.GA2866@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If possible, is there an oportunity to get this last pull before
the end of the merge window done to add the Synopsys Designware
controller driver?

The following changes since commit d888a4c76c51092993643f8992bf55b3c28da483:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../vapier/blackfin

are available in the git repository at:

  git://aeryn.fluff.org.uk/bjdooks/linux.git next-i2c

Baruch Siach (1):
      i2c: driver for the Synopsys DesignWare I2C controller

 drivers/i2c/busses/Kconfig          |    9 +
 drivers/i2c/busses/Makefile         |    1 +
 drivers/i2c/busses/i2c-designware.c |  624 +++++++++++++++++++++++++++++++++++
 3 files changed, 634 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-designware.c
