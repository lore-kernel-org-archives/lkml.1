Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYHBMhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYHBMhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 08:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYHBMhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 08:37:06 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:50797 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbYHBMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 08:37:03 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately  unselectable.
To: Randy Dunlap <randy.dunlap@oracle.com>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 02 Aug 2008 14:41:11 +0200
References: <aTS0O-4U1-33@gated-at.bofh.it> <aTV89-39s-5@gated-at.bofh.it> <aTZYh-4i3-21@gated-at.bofh.it> <aUrrl-78m-3@gated-at.bofh.it> <aUxwQ-1Hn-19@gated-at.bofh.it> <aUERB-Zl-5@gated-at.bofh.it> <aUFXh-3m9-3@gated-at.bofh.it> <aUJ4U-1xe-19@gated-at.bofh.it> <aUJeD-1N6-13@gated-at.bofh.it> <aUUME-5MM-11@gated-at.bofh.it> <aV05W-1wO-41@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KPGQ3-0001T9-RS@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:

> I don't see the "if PARTITION_ADVANCED" block as being compatible with the
> need to have default partition types per $ARCH.
> Do you see some way around that problem?

You need menuconfig_usedefaults.

