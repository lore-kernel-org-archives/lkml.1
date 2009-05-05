Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZEEE5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZEEE5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZEEE5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:57:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:39441 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbZEEE5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:57:10 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 May 2009 14:55:17 +1000
Message-Id: <1241499317.10504.59.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few things still for .30 for you to merge !

Cheers,
Ben.

The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1:
  Linus Torvalds (1):
        Linux 2.6.30-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      powerpc: Fix setting of oprofile cpu type

Grant Likely (1):
      powerpc: Update MPC5xxx and Xilinx Virtex maintainer entries

Michael Wolf (1):
      powerpc adjust oprofile_cpu_type version 3

 MAINTAINERS                    |    4 ++--
 arch/powerpc/kernel/cputable.c |   15 ++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)


