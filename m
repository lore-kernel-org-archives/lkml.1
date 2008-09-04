Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYIDO3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYIDO3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYIDO3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:29:44 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:40076 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbYIDO3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:29:43 -0400
Date: Thu, 4 Sep 2008 16:37:01 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Nir Tzachar <nir@tzachar.com>
cc: 7eggert@gmx.de,
       =?iso-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ncurses based config
In-Reply-To: <9b2db90b0809040517v4478f1b9md69ea07ef9c62c86@mail.gmail.com>
Message-ID: <alpine.LSU.0.999.0809041627170.16019@be1.lrz>
References: <b86dt-3nV-39@gated-at.bofh.it> <b86wB-3HU-1@gated-at.bofh.it> 
 <b86Qa-4k2-53@gated-at.bofh.it> <b879t-4DG-23@gated-at.bofh.it> 
 <E1KbDqF-0003oH-1B@be1.7eggert.dyndns.org>
 <9b2db90b0809040517v4478f1b9md69ea07ef9c62c86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Nir Tzachar wrote:
> On Thu, Sep 4, 2008 at 3:21 PM, Bodo Eggert <7eggert@gmx.de> wrote:

> > In other words: You don't permanently need half a screen of instructions,
> > hide them by default and offer a popup. The window below the title is the
> > only working area, it can be maximized. (Looking at "make menuconfig",
> > I see the same mistakes.)
> 
> I tried to copy the behaviour of menuconfig, hence the similarity.

Obviously. I tried to put the blame on menuconfig by mentioning it.

> Does placing a short help, e.g.,  'press I for instruction' seems
> good?

In this case, I'd just add one more button.
