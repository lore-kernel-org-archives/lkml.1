Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXGBPJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXGBPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXGBPJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:09:21 -0400
Received: from fiberbit.xs4all.nl ([213.84.224.214]:41618 "EHLO
	fiberbit.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbXGBPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:09:20 -0400
Date: Mon, 2 Jul 2007 17:09:15 +0200
From: Marco Roeland <marco.roeland@xs4all.nl>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Blackfin arch: include/asm-blackfin/macros.h die die die
Message-ID: <20070702150915.GC10400@fiberbit.xs4all.nl>
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain> <4688EF9B.8020405@garzik.org> <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com> <4689073D.1020802@garzik.org> <81b0412b0707020722q25e8eb41t456e7316fe4a7b40@mail.gmail.com> <20070702142926.GB10400@fiberbit.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20070702142926.GB10400@fiberbit.xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This file accidentally got truncated instead of deleted in commit df30b11.
Doing a "make distclean" or "make mrproper" deletes this file because of
its zero size. Git then sees this as an uncommitted local change.

Signed-off-by: Marco Roeland <marco.roeland@xs4all.nl>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 include/asm-blackfin/macros.h

diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
deleted file mode 100644
index e69de29..0000000
-- 
1.5.2.2.1451.gb0e5e
