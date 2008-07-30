Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYG3Pds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYG3Pds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYG3Pdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:33:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38216 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYG3Pdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:33:39 -0400
Date: Wed, 30 Jul 2008 18:32:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jon Smirl <jonsmirl@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080730153247.GA21597@cs181140183.pp.htv.fi>
References: <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au> <20080728234131.GD28055@linux-sh.org> <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com> <488E644D.7000507@keyaccess.nl> <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com> <488EF377.5080603@keyaccess.nl> <20080730072448.GB1564@cs181140183.pp.htv.fi> <4890284E.3050806@s5r6.in-berlin.de> <20080730124650.GB19966@cs181140183.pp.htv.fi> <4890646D.3060000@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4890646D.3060000@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 02:54:05PM +0200, Rene Herman wrote:
> On 30-07-08 14:46, Adrian Bunk wrote:
>
>> On Wed, Jul 30, 2008 at 10:37:34AM +0200, Stefan Richter wrote:
>>> Adrian Bunk wrote:
>>> ...
>>>> but as soon as someone puts an email address into a kernel commit
>>>> Google will anyway find it:
>>> This doesn't justify what Jon did though.
>>>
>>> Jon created a new database out of formerly disparate datasets, even
>>> though we didn't provide him these datasets for this purpose.  The fact
>>> that the means to create this database are rather trivial and cheap do
>>> not mean that we implicitly agreed to what he did or that it wouldn't
>>> matter whether we agree to it or not.
>>> ...
>>
>> You certified:
>
> You only certify anything when _you_ put your address in. Given that  
> it's a very common occurence that not you but _others_ do, this does not  
> mean a _single_ thing. Tested-by, Bisected-by, what have you...
>
> But let us leave this discussion be. It's not going anywhere anyway.

There's one thing where it might actually go further:

You actually have a good point here, and I'm not disagreeing with it.

I've added Linus to the recipients since stuff like e.g. Tested-by or 
Bisected-by tags actually undermine what the DCE 1.1 update should
have accomplished. So if DCE 1.1 (d) is considered to be legally 
required for public indefinite storage of name and email address
we have a problem here.

> Rene.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

