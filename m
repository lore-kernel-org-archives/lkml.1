Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZLUTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZLUTKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbZLUTKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:10:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbZLUTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:10:30 -0500
Date: Mon, 21 Dec 2009 20:10:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [GIT PULL] Please pull hwpoison fixes for 2.6.33-rc1
Message-ID: <20091221191026.GA26493@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the hwpoison fixes for 2.6.33-rc1.

Only one small patch to fix a compilation problem with disabled
PROC_FS found by Ingo's testing

Thanks,

-Andi

The following changes since commit dd59f6c76b265ed2ff18b497d6105a9511b1feb1:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../mattst88/alpha-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison

Andi Kleen (1):
      HWPOISON: Add PROC_FS dependency to hwpoison injector v2

 mm/Kconfig          |    2 +-
 mm/memory-failure.c |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

-- 
ak@linux.intel.com -- Speaking for myself only.
