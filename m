Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYGBMln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYGBMln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYGBMlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:41:35 -0400
Received: from ozlabs.org ([203.10.76.45]:44276 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYGBMle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:41:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18539.30579.62610.116128@cargo.ozlabs.ibm.com>
Date: Wed, 2 Jul 2008 22:41:23 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get two more small bug-fixes for powerpc, as listed below.

Thanks,
Paul.

 arch/powerpc/boot/Makefile          |    3 ++-
 arch/powerpc/kernel/legacy_serial.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletions(-)

John Linn (2):
      powerpc/bootwrapper: update for initrd with simpleImage
      powerpc/legacy_serial: Bail if reg-offset/shift properties are present

