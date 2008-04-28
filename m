Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbYD1IVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbYD1IVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765973AbYD1IVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:21:04 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47400 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765843AbYD1IVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:21:02 -0400
Date: Mon, 28 Apr 2008 11:20:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Priit Laes <plaes@plaes.org>
Subject: Re: [PATCH] Fix compile error with wifi & leds
Message-ID: <20080428082030.GD16379@cs181133002.pp.htv.fi>
References: <20080426203408.GA12074@dreamland.darkstar.lan> <20080428074531.GA16379@cs181133002.pp.htv.fi> <20080428075452.GB16379@cs181133002.pp.htv.fi> <1ba2fa240804280118l5f813b38n8291789342b1d802@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1ba2fa240804280118l5f813b38n8291789342b1d802@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:18:08AM +0300, Tomas Winkler wrote:
> On Mon, Apr 28, 2008 at 10:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Mon, Apr 28, 2008 at 10:45:31AM +0300, Adrian Bunk wrote:
> >  > Can you send the .config that gives this problem?
> >
> >  Scrap that, I already got the problem (and your patch looks right).
> >
> >
> 
> I think it's time to be applied so we won't get another 5 of them.
> Please add also  Priit Laes <plaes@plaes.org>  as he was first to
> provide a patch

David already sent a pull request that includes Luca's patch to Linus.

My question was due to me first misunderstanding what's happening here.

> Thanks
> Tomas

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

