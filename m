Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZKDW2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZKDW2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZKDW2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:28:39 -0500
Received: from mail.lang.hm ([64.81.33.126]:44660 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbZKDW2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:28:39 -0500
Date: Wed, 4 Nov 2009 14:28:40 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Marcin Letyns <mletyns@gmail.com>
cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <f42384a10911041419t5d13f330g7f74675ab45c0bb2@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0911041422580.6343@asgard.lang.hm>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>  <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>  <200911041848.48721.tweek@tweek.dk>  <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>  <22108.1257364949@turing-police.cc.vt.edu>
  <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz>  <23950.1257367315@turing-police.cc.vt.edu>  <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>  <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com> 
 <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz> <f42384a10911041419t5d13f330g7f74675ab45c0bb2@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Marcin Letyns wrote:

> 2009/11/4 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>:
>>
>> It interferred with my will to install the version of the software that I
>> want.
>
> You did it in very idiotic way...

he's not alone in trying to do this

package managers are wonderful when they work and the package you need is 
in there. they are a pain to be worked around when the package you want 
isn't in the repository. if the package just isn't in there it's not a big 
deal to deal with it, the problem comes when you want a package that's 
different from one that _is_ in the repository.

how easy or hard it is to work around the package manager depends in large 
part on if you know the tricks for that particular package manager.

and no, a rolling update distro doesn't solve the problem. one issue is 
that trying to upgrade one package may trigger a pull of many others, but 
the bigger problem shows up when you need to compile a package with 
different options and really need to tell the package manager "hands off, 
I'll do this manually". They all have a way to do this, but most of the 
time it means learning enough about how packages work on that system to be 
able to create a dummy package to trick the package manager.

I think both sides here are overstating it.

package managers are neither the solution to all possible problems, nor 
are they the root of all evil.

David Lang

>>
>> If you need new 3D driver because of better gaming performance ... if you
>> need new lame because it encodes mp3 better ... if you need new libsane
>> because it supports the new scanner that you have ... you are going to
>> face the same problems like me when I needed new binutils. But the big
>> problem is that persons needing these things usually don't have enough
>> skills to install the software on their own and then fight with the
>> package management system.
>
> You use a rolling distro or add a proper repository with newer
> packages. Nope, I never faced such problems, but I'm smart enough to
> install software in a proper way. I consider package managers being
> killer features you can only dream about being windows user.
>
>> On Windows, the user can just download the EXE, run it, click
>> next-next-next-finish and have it installed. There is no package
>> management that would try to overwrite what you have just installed.
>
> On windows, user cannot upgrade entire system in such easy way (he
> can't even install a thing in such easy way) as Linux distros let you
> to do so. I recommend you to stop writing such bull. It was you, who
> wanted to overwrite what you have just installed. Stop trolling.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
