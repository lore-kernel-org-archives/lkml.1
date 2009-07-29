Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZG2Cij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZG2Cij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbZG2Cii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:38:38 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40856 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbZG2Cii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:38:38 -0400
Date: Tue, 28 Jul 2009 22:38:38 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yoichi Yuasa <yyuasa@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] remove zero-length file in tree
Message-ID: <20090729023838.GA15427@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'zero-length' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git zero-length

to receive the following updates:

 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 drivers/char/vr41xx_giu.c

Jeff Garzik (1):
      Remove zero-length file drivers/char/vr41xx_giu.c

diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
deleted file mode 100644
index e69de29..0000000
