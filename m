Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZISWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZISWqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZISWqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:46:54 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:33793 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbZISWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:46:54 -0400
To: apkm@linux--foundation.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Please pull bjdooks' i2c tree
From: Ben Dooks <ben-linux@fluff.org>
Message-Id: <E1Mp8hY-0006EA-7X@kira.home.fluff.org>
Date: Sat, 19 Sep 2009 23:46:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 78f28b7c555359c67c2a0d23f7436e915329421e:
  Linus Torvalds (1):
        Merge branch 'x86-platform-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://aeryn.fluff.org.uk/bjdooks/linux.git next-i2c

Mikael Pettersson (1):
      i2c-mv64xxx: correct mv64xxx_i2c_intr() return type

Wolfram Sang (1):
      i2c-imx: make bus available early

 drivers/i2c/busses/i2c-imx.c     |    3 +--
 drivers/i2c/busses/i2c-mv64xxx.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)
