Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYFRNSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYFRNSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYFRNSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:18:15 -0400
Received: from ozlabs.org ([203.10.76.45]:60780 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbYFRNSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:18:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18521.2804.318527.293516@cargo.ozlabs.ibm.com>
Date: Wed, 18 Jun 2008 23:17:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get two more small bug-fixes for powerpc, as listed below.

Thanks,
Paul.

 arch/powerpc/kernel/head_44x.S |    7 ++++++-
 arch/powerpc/mm/hash_low_64.S  |    4 ++++
 2 files changed, 10 insertions(+), 1 deletions(-)

Josh Boyer (1):
      [POWERPC] 4xx: Clear new TLB cache attribute bits in Data Storage vector

Paul Mackerras (1):
      [POWERPC] Clear sub-page HPTE present bits when demoting page size

