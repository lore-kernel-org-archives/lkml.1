Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab0CAN0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:26:07 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:56433 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0CAN0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:26:04 -0500
Date: Mon, 1 Mar 2010 14:25:01 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: [GIT PULL] CRIS updates for 2.6.34
Message-ID: <20100301132501.GF4219@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull the below repo for some minor CRIS-fixes.

Thanks!

The following changes since commit 1836d95928a0f41ada0cbb2a6c4e46b027db9491:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ericvh/v9fs

are available in the git repository at:

  git://repo.or.cz/cris-mirror.git for-linus

Roel Kluin (1):
      CRIS v32: Should index be positive?

Thomas Gleixner (1):
      cris: Fixup last users of irq_chip->typename

 arch/cris/arch-v10/kernel/irq.c     |    2 +-
 arch/cris/arch-v32/kernel/irq.c     |    2 +-
 arch/cris/arch-v32/kernel/pinmux.c  |    4 ++--
 arch/cris/arch-v32/mach-a3/pinmux.c |    2 +-
 arch/cris/arch-v32/mach-fs/pinmux.c |    4 ++--
 arch/cris/kernel/irq.c              |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
