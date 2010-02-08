Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0BHGQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:16:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:55980 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0BHGQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:16:19 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 17:16:06 +1100
Message-ID: <1265609766.8287.234.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a small regression fix that should still make it into .33

Cheers,
Ben.

The following changes since commit 6339204ecc2aa2067a99595522de0403f0854bb8:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Mark Nelson (1):
      powerpc/pseries: Fix kexec regression caused by CPPR tracking

 arch/powerpc/platforms/pseries/xics.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)


