Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbXICKX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbXICKX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbXICKXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:23:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44510 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752717AbXICKXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:23:46 -0400
Date: Mon, 3 Sep 2007 12:23:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Jan Dittmer <jdi@l4x.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
Subject: Re: [1/4] 2.6.23-rc5: known regressions
Message-ID: <20070903102347.GQ16016@stusta.de>
References: <46DBDD6E.9020007@googlemail.com> <46DBDDF0.3090203@l4x.org> <6bffcb0e0709030314t28c0102dr41f3c7b75b134cfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6bffcb0e0709030314t28c0102dr41f3c7b75b134cfa@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 12:14:05PM +0200, Michal Piotrowski wrote:
> On 03/09/07, Jan Dittmer <jdi@l4x.org> wrote:
> > Michal Piotrowski wrote:
> > > Subject         : 2.6.23-rc2 cross compile regressions (alpha,xtensa)
> > > References      : http://lkml.org/lkml/2007/8/6/43
> > > Last known good : alpha: 2.6.22-git8
> > >                   xtensa: 2.6.22-git6
> > > Submitter       : Jan Dittmer <jdi@l4x.org>
> > > Caused-By       : ?
> > > Handled-By      : xtensa: Christian Zankel <chris@zankel.net>
> > > Status          : unknown
> >
> > Both are fixed as of -rc5
> 
> Thanks. I will try to figure out who fixed these bugs.

alpha was commit aa137f9d29d30592774c727ec5cfcf9891e576fa
xtensa was commit b5f281a62761887e7cb5f60fa81f7cd052fec5cb

> Regards,
> Michal

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

