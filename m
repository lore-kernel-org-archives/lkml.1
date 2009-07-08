Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZGHNx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZGHNx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbZGHNxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:53:50 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48454 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZGHNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:53:50 -0400
Date: Wed, 8 Jul 2009 14:53:27 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090708135327.GA21508@shareable.org>
References: <19013.8005.541836.436991@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <200907081339.59815.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907081339.59815.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> I don't believe that Microsoft is still providing updates for Win98. But I 
> think Windows 2000 might still be in use

Definitely.  The mail server belonging to a company that pays me for
embedded Linux work runs on Windows 2000.  I moved it to a virtual
machine about 1 year ago - it's still in use.

> - I for example have a Win 2000 
> installation on my ThinkPad T23, although I didn't boot it for about a 
> year or so. Has it been tested against Windows 2000? I digged for the mail 
> where you said something about against which Windows versions you tested, 
> but I didn't find it anymore.

Heh.  I still use Windows 95 and Windows 98 occasionally.  I'm a bit
disappointed to find Samba no longer tests against them :-)

I wouldn't be surprised if Windows ME has fewer users than 98.  98 had
a reputation for being the best of the non-NT series.

> > When the vendor of an operating system doesn't even bother to display
> > a clean "sorry, you don't get updates any more" page for their OS then
> > I think it is safe to say that the operating system is dead and
> > buried.
> 
> It is safe to say much. But still users might not behave according to your 
> saying or might even not be able to. A potential customer asked us to 
> migrate a Windows 98 installation into a virtual machine, cause the 
> software that is running there would not run with any newer version of 
> Windows. Sometimes people are locked / forced to a specific Windows (or 
> Linux) version at least is they do not want to pay lots of $$$ to replace 
> their proprietary special hardware + software combination by something 
> which is supported on a newer version of an operating system. And for a 
> coincidence I think digital photos have been involved in that use case.

I think you've described commercial ancient Windows users.

But I suspect there are more non-commercial users - that ancient PC
someone has in their home which is good enough at running Word 2 for
_their_ word processing needs.  You know the sort of thing: ancient
14-inch CRT still going strong, friend probably replaced the disk 5
years ago and cloned the original working OS, fan's getting a bit
noisy but the old clunker isn't worth replacing just yet.

-- Jamie
