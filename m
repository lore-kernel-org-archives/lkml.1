Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZCQSeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZCQSeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbZCQSeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:34:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46843 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZCQSeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:34:24 -0400
Subject: [git-pull -tip] x86: mpparse cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 00:03:56 +0530
Message-Id: <1237314836.3212.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0ca0f16fd17c5d880dd0abbe03595b0c7c5b3c95:
  Ingo Molnar (1):
        Merge branches 'x86/apic', 'x86/asm', 'x86/cleanups', 'x86/debug', 'x86/kconfig', 'x86/mm', 'x86/ptrace', 'x86/setup' and 'x86/urgent'; commit 'v2.6.29-rc8' into x86/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core

Jaswinder Singh Rajput (1):
      x86: mpparse cleanup

 arch/x86/kernel/mpparse.c |  311 +++++++++++++++++++++------------------------
 1 files changed, 146 insertions(+), 165 deletions(-)


