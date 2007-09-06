Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbXIFWoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbXIFWoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932335AbXIFWn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:43:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51144 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753859AbXIFWnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:43:55 -0400
Date: Fri, 7 Sep 2007 00:43:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
Message-ID: <20070906224358.GG4480@stusta.de>
References: <200709051946.12096.vda.linux@googlemail.com> <20070905203438.GG475@flower.upol.cz> <200709061155.46667.vda.linux@googlemail.com> <20070906114044.GM475@flower.upol.cz> <20070906122143.GM16016@stusta.de> <20070906204349.GO475@flower.upol.cz> <20070906203931.GE4480@stusta.de> <E1ITOhz-0001wd-Uu@flower> <20070906211955.GF4480@stusta.de> <E1ITPQC-0004Ye-JF@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1ITPQC-0004Ye-JF@flower>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 12:01:56AM +0200, Oleg Verych wrote:
>...
> > And code review and Denys' patch have cumulative effects since his patch 
> > results in improvements that can't be resonably done other than at 
> > the ld and/or gcc level.
> 
> I was talking about introducing such things in development process.
> Current kconfig may be not flexible, it must not lead to further problems
> and silver-bullet solutions.
>...

The patches in this thread are not in any way related to any problems 
with kconfig...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

