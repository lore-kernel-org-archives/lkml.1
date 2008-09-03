Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYICHgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYICHgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYICHgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:36:31 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59898 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYICHgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:36:31 -0400
Date: Wed, 3 Sep 2008 10:36:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] m68k: Reverse platform MMU logic so Sun 3 is last
Message-ID: <20080903073629.GD4104@cs181140183.pp.htv.fi>
References: <20080903071542.615137611@mail.of.borg> <20080903071741.424551678@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080903071741.424551678@mail.of.borg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:15:44AM +0200, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Currently Sun 3 support is the first platform option, as the Sun 3 MMU is
> incompatible with standard Motorola MMUs. However, this means that
> `allmodconfig' enables support for Sun 3, and thus disables support for all
> other platforms.
>...

I hope it isn't too heretical to ask whether Sun 3 support actually has 
users and works?

Apollo support was broken for over 7 years without anyone noticing, and 
it might not be the only m68k platform that is long unused.

Do you have any overview of which m68k platforms still have users?

> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

