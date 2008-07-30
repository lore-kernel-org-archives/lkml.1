Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYG3HZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYG3HZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYG3HZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:25:39 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39232 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYG3HZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:25:38 -0400
Date: Wed, 30 Jul 2008 10:24:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jon Smirl <jonsmirl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080730072448.GB1564@cs181140183.pp.htv.fi>
References: <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com> <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com> <20080728141414.d7e5def2.randy.dunlap@oracle.com> <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au> <20080728234131.GD28055@linux-sh.org> <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com> <488E644D.7000507@keyaccess.nl> <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com> <488EF377.5080603@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <488EF377.5080603@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 12:39:51PM +0200, Rene Herman wrote:
> On 29-07-08 02:50, Jon Smirl wrote:
>
>>>> Why do these all end in (none)?
>>>> Craig Hughes <craig@com.rmk.(none)>
>>>> Dave Neuer <dneuer@org.rmk.(none)>
>>>> David Brownell <david-b@net.rmk.(none)>
>>>> David Woodhouse <dwmw2@org.rmk.(none)>
>>>> Deepak Saxena <dsaxena@net.rmk.(none)>
>>>> Enrico Scholz <enrico.scholz@de.rmk.(none)>
>>>>
>>>  Because rmk rewrites addresses to comply with privacy laws. Another good
>>> example of why this nonsense of yours is exactly that.
>>>
>>>  I checked and am personally in there three times, once even without any
>>> valid email address listed. And any time there's anything other than my
>>> gmail address in some submission it at least recently means that someone
>>> _else_ took my from: address and stuck it on there and while I don't
>>> terribly mind that generally, I find it really annoying to see even those
>>> mistakes harvested into your hugely google-accessible resource.
>
> [ .. ]
>
>> As for privacy, if you don't want your email address in a file like
>> this don't put it into a GPL'd public project.
>
> Like I told you, I don't. Others do. And while that's not a huge issue  
> in itself, you harvesting it into your nicely formatted google and  
> spam-base MAKES it an issue. Just stop this crap. Be away.

Whether Jon's patch is a good idea one might discuss, but as soon as 
someone puts an email address into a kernel commit Google will anyway 
find it:

The ChangeLog-* files at http://ftp.kernel.org/pub/linux/kernel/v2.6/ 
also contain all addresses in Jon's list, and Google harvests them.
The same goes for mailing list archives of git-commits-head.

> Rene.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

