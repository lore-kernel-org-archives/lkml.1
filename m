Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYLACbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYLACbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 21:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYLACbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 21:31:21 -0500
Received: from ozlabs.org ([203.10.76.45]:55184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbYLACbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 21:31:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18739.19567.116894.316340@cargo.ozlabs.ibm.com>
Date: Mon, 1 Dec 2008 13:31:11 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch again
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do another pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

Sorry for a second request so soon after the previous one, but I
realized that I had missed one commit that I intended to include, and
without it our 32-bit SMP configs won't compile.

Thanks,
Paul.

 arch/powerpc/kernel/sysfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Milton Miller (1):
      powerpc: Fix build for 32-bit SMP configs

