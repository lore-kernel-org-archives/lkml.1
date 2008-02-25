Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbYBYUKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbYBYUKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYBYUKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:10:04 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60184 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbYBYUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:10:03 -0500
Date: Mon, 25 Feb 2008 22:09:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Message-ID: <20080225200903.GB13635@cs181133002.pp.htv.fi>
References: <30804.1203962369@turing-police.cc.vt.edu> <47C3078E.3000008@redhat.com> <20080225181957.4eeed15d@core> <20080225192710.GA13635@cs181133002.pp.htv.fi> <20080225194835.GA28042@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225194835.GA28042@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 02:48:35PM -0500, Alan Cox wrote:
> On Mon, Feb 25, 2008 at 09:27:10PM +0200, Adrian Bunk wrote:
> > > As I understand it if Vladis wants to submit his own change to the symbol
> > > thats up to him, and he'll be liable for any fallout with the FSF, or
> > > harm to Linux resulting, so long he's the one who signs it off.
> > 
> > Why isn't anyone distributing it liable if it is not legally correct?
> 
> They may well be, but they all get to sue Vladis in turn

Being able to sue someone who has so many lawsuits that there's anyway 
no money left for me sounds like a bad compensation for serving a few 
years in jail... [1]

> Alan

cu
Adrian

[1] OK, realistically that's not enough for a jail sentence

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

