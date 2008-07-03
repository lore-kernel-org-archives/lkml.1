Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYGCAJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYGCAJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 20:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYGCAJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 20:09:35 -0400
Received: from ozlabs.org ([203.10.76.45]:56876 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYGCAJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:09:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18540.6326.714792.742146@cargo.ozlabs.ibm.com>
Date: Thu, 3 Jul 2008 10:09:26 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <18539.30579.62610.116128@cargo.ozlabs.ibm.com>
References: <18539.30579.62610.116128@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Grant Likely sent me one more bug-fix for 2.6.26, which I have merged
into my merge branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

So when you do the pull from there, you'll get 3 commits as listed
below.

Thanks,
Paul.

 arch/powerpc/boot/Makefile                |    3 ++-
 arch/powerpc/kernel/legacy_serial.c       |    5 +++++
 arch/powerpc/platforms/52xx/lite5200_pm.c |   14 +++++++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

John Linn (2):
      powerpc/bootwrapper: update for initrd with simpleImage
      powerpc/legacy_serial: Bail if reg-offset/shift properties are present

Tim Yamin (1):
      powerpc/mpc5200: Fix lite5200b suspend/resume

