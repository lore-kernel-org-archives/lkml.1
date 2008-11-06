Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYKFCdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYKFCdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYKFCdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:33:37 -0500
Received: from ozlabs.org ([203.10.76.45]:37674 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbYKFCdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:33:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18706.21588.724885.947504@cargo.ozlabs.ibm.com>
Date: Thu, 6 Nov 2008 13:20:04 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get three small commits that fix compile errors and a warning on
powerpc.

Thanks,
Paul.

 arch/powerpc/platforms/cell/ras.c          |    1 +
 arch/powerpc/platforms/pseries/pci_dlpar.c |    1 -
 drivers/ps3/ps3-lpm.c                      |    1 +
 3 files changed, 2 insertions(+), 1 deletions(-)

Alexey Dobriyan (2):
      powerpc/ps3: Fix compile error in ps3-lpm.c
      powerpc/cell: Fix compile error in ras.c

Stephen Rothwell (1):
      powerpc: Fix "unused variable" warning in pci_dlpar.c

