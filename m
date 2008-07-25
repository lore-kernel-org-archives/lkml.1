Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYGYXLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYGYXLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbYGYXLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:11:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:45006 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345AbYGYXLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:11:24 -0400
Subject: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Jul 2008 09:11:13 +1000
Message-Id: <1217027473.11188.120.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Please pull from:
﻿
﻿git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

To get one patch that fixes a boot problem introduced by yesterday's
serie.

Thanks !
Ben.

 arch/powerpc/kernel/cputable.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Nathan Lynch (1):
      powerpc: Fix boot problem due to AT_BASE_PLATFORM change



