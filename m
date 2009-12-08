Return-Path: <linux-kernel-owner+w=401wt.eu-S937021AbZLHXbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937021AbZLHXbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936998AbZLHXbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:31:42 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51983 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936980AbZLHXbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:31:42 -0500
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Please pull bjdooks' git tree
From: Ben Dooks <ben-linux@fluff.org>
Message-Id: <E1NI9YG-0003dB-54@teyla.home.fluff.org>
Date: Tue, 08 Dec 2009 23:33:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6035ccd8e9e40bb654fbfdef325902ab531679a5:
  Linus Torvalds (1):
        Merge branch 'for-2.6.33' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git s3c24xx-updates

Ben Dooks (1):
      ARM: S3C24XX: Export s3c24xx_set_fiq for modules.

Ramax Lo (1):
      ARM: S3C24XX: DMA: Use valid index when accessing array

Uwe Kleine-König (2):
      ARM: S3C: move s3c_adc_remove to .devexit.text
      ARM: S3C: move s3c_pwm_remove to .devexit.text

 arch/arm/plat-s3c/pwm.c     |    2 +-
 arch/arm/plat-s3c24xx/adc.c |    2 +-
 arch/arm/plat-s3c24xx/dma.c |    6 ++++--
 arch/arm/plat-s3c24xx/irq.c |    2 ++
 4 files changed, 8 insertions(+), 4 deletions(-)
