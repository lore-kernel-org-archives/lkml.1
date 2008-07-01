Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYGANiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYGANiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYGANh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:37:58 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:63277 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbYGANh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:37:57 -0400
Date: Tue, 1 Jul 2008 14:37:39 +0100
From: Ben Dooks <ben-linu@fluff.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: i2c pull request for s3c24xx driver
Message-ID: <20080701133739.GA7933@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull request for i2c driver fixes to the S3C24XX i2c driver
suitable for applying to the current kernel.

Linus please take this unless Jean wants to pull this into
his own i2c tree.

The following changes since commit e1441b9a41c33aa9236008a7cfe49a8e723fb397:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input

are available in the git repository at:

  git://aeryn.fluff.org.uk/bjdooks/linux.git i2c-fix

Ben Dooks (3):
      I2C: S3C2410: Check ACK on byte transmission
      I2C: S3C2410: Fixup error codes returned rom a transfer.
      I2C: S3C2410: Add MODULE_ALIAS() for s3c2440 device.

 drivers/i2c/busses/i2c-s3c2410.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)
