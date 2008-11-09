Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYKISN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYKISN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 13:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYKISNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 13:13:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:34580 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbYKISNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 13:13:18 -0500
Date: Sun, 9 Nov 2008 10:14:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, hpa@zytor.com
Subject: Move iomap.h to arch/x86/include/asm
Message-ID: <20081109101405.6981b835@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The following changes since commit
a622cf69b806bbb1887913c04e01d0c25b892876: Linus Torvalds (1):
        Merge branch 'sched-fixes-for-linus' of
git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-kerneloops.git
  for-mingo

Arjan van de Ven (1):
      x86: move iomap.h to the new include location

 {include/asm-x86 => arch/x86/include/asm}/iomap.h |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename {include/asm-x86 => arch/x86/include/asm}/iomap.h (100%)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
