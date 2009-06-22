Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZFVAu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZFVAu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 20:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZFVAuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 20:50:50 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:37598 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750996AbZFVAut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 20:50:49 -0400
To: apkm@linux-foundation.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Please pull bjdooks' i2c tree
From: Ben Dooks <ben-linux@fluff.org>
Message-Id: <E1MIXkA-0005wC-2l@kira.home.fluff.org>
Date: Mon, 22 Jun 2009 01:50:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f234012f52a37e48f2330e1ca2df69800e797c3b:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../drzeus/mmc

are available in the git repository at:

  git://aeryn.fluff.org.uk/bjdooks/linux.git next-i2c

Michael Trimarchi (1):
      i2c: Fix stuck transaction on cpm-i2c driver

Tony Lindgren (1):
      i2c-omap: Fix build breaking typo cpu_is_omap_2430

 drivers/i2c/busses/i2c-cpm.c  |    6 +++---
 drivers/i2c/busses/i2c-omap.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
