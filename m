Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZBKFQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZBKFQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 00:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZBKFQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 00:16:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:48628 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZBKFQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 00:16:12 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 16:15:28 +1100
Message-Id: <1234329328.29851.16.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is a single patch, to fix a regression introduced in this merge
window. Please apply.

The following changes since commit 1db8508cf483dc1ecf66141f90a7c03659d69512:
  Stefan Richter (1):
        hugetlbfs: fix build failure with !CONFIG_HUGETLBFS

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Kumar Gala (1):
      powerpc/mm: Fix _PAGE_COHERENT support on classic ppc32 HW

 arch/powerpc/mm/hash_low_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


