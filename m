Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbYCDSZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbYCDSZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbYCDSZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:25:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:45002 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbYCDSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lEFj46n9K5XQZyyoj57B721qK9D0uCKxwy/CxQrQCL2prDzSe47Fr4pfhmrdl4C8Pb/zz0Rw0uQ4mx95LvwSgMRPomXOBIUZitC5J8E/hh+lePpGIh8vkOWX7KayxvxSX8kqtV6RN8gKgo3NEUYWH/elI9OI9Hd2l3amK2FJazA=
Message-ID: <6101e8c40803041025m5f9103e3j38bf5d46caf98e75@mail.gmail.com>
Date: Tue, 4 Mar 2008 19:25:27 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [OP] linux v2.6.22.20-op1
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I (Oliver Pinter) announced the v2.6.22.20-op1 "stable" kernel.

gitweb: http://repo.or.cz/w/linux-2.6.22.y-op.git
git-tree: git://repo.or.cz/linux-2.6.22.y-op.git
patches-gitweb : http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
tar-bz2: http://students.zipernowsky.hu/~oliverp/kernel-stable/v2.6.22.20-op1.tar.bz2
patch: http://students.zipernowsky.hu/~oliverp/kernel-stable/patch-v2.6.22.19-v2.6.22.20-op1.bz2
chlog: http://students.zipernowsky.hu/~oliverp/kernel-stable/chlog-v2.6.22.20-op1
======================================
Makefile | 2 +-
arch/x86_64/mm/pageattr.c | 2 +-
include/linux/page-flags.h | 4 ++--
kernel/irq/chip.c | 20 +++++++++++++++++++-
mm/vmscan.c | 41 +++++++++++++++++++++++++++++++++++++++++
5 files changed, 64 insertions(+), 5 deletions(-)
======================================
chlog v2.6.22.19..v2.6.22.20-op1:
----------------------------------------------------
David Howells (1):
MM: Fix macro argument substitution in PageHead() and PageTail()
Ingo Molnar (1):
x86_64: CPA, fix cache attribute inconsistency bug, v2.6.22 backport
Kurt Garloff (1):
make (low) swappiness safer to use
Oliver Pinter (1):
linux v2.6.22.20-op1
Thomas Gleixner (1):
genirq: do not leave interupts enabled on free_irq
======================================
Thanks,
Oliver
/* http://students.zipernowsky.hu/~oliverp/ */
