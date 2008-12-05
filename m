Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYLEAr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYLEAr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYLEAru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:47:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:34639 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYLEAru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:47:50 -0500
Date: Thu, 4 Dec 2008 18:47:41 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Paul Mackerras <paulus@samba.org>
cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: Please pull from 'merge' branch (for 2.6.28)
Message-ID: <Pine.LNX.4.64.0812041847240.5780@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'merge' branch of

	master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git merge

to receive the following updates:

 arch/powerpc/configs/83xx/mpc834x_itx_defconfig |    2 +-
 arch/powerpc/configs/mpc83xx_defconfig          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Anton Vorontsov (1):
      powerpc/83xx: Enable FIXED_PHY in mpc834x_itx and mpc83xx defconfigs

