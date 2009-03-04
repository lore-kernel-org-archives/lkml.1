Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZCDGlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZCDGlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCDGk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:40:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:43892 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZCDGk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:40:57 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 17:40:42 +1100
Message-Id: <1236148843.6696.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a fix for a USB related regression on some PowerPC machines.

The following changes since commit fec6c6fec3e20637bee5d276fb61dd8b49a3f9cc:
  Linus Torvalds (1):
        Linux 2.6.29-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Tony Breeds (1):
      powerpc: Run sbc610 USB fixup code only on the appropriate platform.

 arch/powerpc/platforms/86xx/gef_sbc610.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


