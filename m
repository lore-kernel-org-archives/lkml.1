Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZFBXXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZFBXXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZFBXXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:23:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:56285 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZFBXXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:23:24 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 09:22:42 +1000
Message-Id: <1243984962.27194.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a defconfig update if you still get things in .30

Cheers,
Ben.

The following changes since commit d9244b5d2fbfe9fa540024b410047af13ceec90f:
  Linus Torvalds (1):
        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      powerpc/pmac: Update PowerMac 32-bit defconfig

 arch/powerpc/configs/pmac32_defconfig |  278 +++++++++++++++++++++++----------
 1 files changed, 195 insertions(+), 83 deletions(-)


