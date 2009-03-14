Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZCNQNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZCNQNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZCNQNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:13:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:49171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbZCNQNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:13:32 -0400
Subject: [git-pull -tip] x86: cleanup patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 21:43:08 +0530
Message-Id: <1237047188.4546.31.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4cca0345b9c1ee3573bcd0ea5feb3b44caa7930c:
  Ingo Molnar (1):
        Merge branch 'tracing/ftrace'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master

Jaswinder Singh Rajput (9):
      x86: cpu/intel.c cleanup
      x86: i8237.c cleanup
      x86: topology.c cleanup
      x86: kdebugfs.c cleanup
      x86: i8253 cleanup
      x86: pci-nommu.c cleanup
      x86: io_delay.c cleanup
      x86: rtc.c cleanup
      x86: trampoline.c cleanup

 arch/x86/kernel/cpu/intel.c  |  186 +++++++++++++++++++++---------------------
 arch/x86/kernel/i8237.c      |    5 +-
 arch/x86/kernel/i8253.c      |   25 +++---
 arch/x86/kernel/io_delay.c   |    6 +-
 arch/x86/kernel/kdebugfs.c   |   35 +++++---
 arch/x86/kernel/pci-nommu.c  |   29 ++++--
 arch/x86/kernel/rtc.c        |   22 +++--
 arch/x86/kernel/topology.c   |   10 ++-
 arch/x86/kernel/trampoline.c |    3 +-
 9 files changed, 175 insertions(+), 146 deletions(-)


