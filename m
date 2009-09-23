Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZIWGy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZIWGy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZIWGy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:54:28 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:60416
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754011AbZIWGy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:54:27 -0400
Subject: [GIT PULL] score patches for 2.6.32
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, liqin.gnu@gmail.com
Content-Type: text/plain
Date: Wed, 23 Sep 2009 14:40:17 +0800
Message-Id: <1253688017.27225.12.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of
  git://gitserver.sunplusct.com/linux-2.6-score for-linus
to receive following updates

The following changes since commit 7fa07729e439a6184bd824746d06a49cca553f15:
  Linus Torvalds (1):
        Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://gitserver.sunplusct.com/linux-2.6-score for-linus

Chen Liqin (1):
      score: update email address in MAINTAINERS.

Tim Abbott (3):
      score: Make PAGE_SIZE available to assembly.
      score: Make THREAD_SIZE available to assembly files.
      score: Cleanup linker script using new macros.

 MAINTAINERS                          |    2 +-
 arch/score/include/asm/page.h        |    3 +-
 arch/score/include/asm/thread_info.h |   15 ++++---
 arch/score/kernel/vmlinux.lds.S      |   77 ++++------------------------------
 4 files changed, 21 insertions(+), 76 deletions(-)


