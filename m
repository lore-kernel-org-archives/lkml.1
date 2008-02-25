Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYBYT2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYBYT2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbYBYT2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:28:11 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42334 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263AbYBYT2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:28:09 -0500
Date: Mon, 25 Feb 2008 21:27:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Rostedt <srostedt@redhat.com>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Message-ID: <20080225192710.GA13635@cs181133002.pp.htv.fi>
References: <30804.1203962369@turing-police.cc.vt.edu> <47C3078E.3000008@redhat.com> <20080225181957.4eeed15d@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225181957.4eeed15d@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 06:19:57PM +0000, Alan Cox wrote:
> > The reason I added GPL is not because of some idea that this is all 
> > "chummy" with the kernel. But because I derived the mcount code from 
> > glibc's version of mcount. Now you may argue that glibc is under LGPL 
> > and a non-GPL export is fine. But I've been advised that if I ever take 
> > code from someone else, to always export it with GPL.
> 
> As I understand it if Vladis wants to submit his own change to the symbol
> thats up to him, and he'll be liable for any fallout with the FSF, or
> harm to Linux resulting, so long he's the one who signs it off.
>...

Why isn't anyone distributing it liable if it is not legally correct?

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

