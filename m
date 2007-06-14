Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbXFNXTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbXFNXTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXFNXSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:18:37 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:15354 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbXFNXSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B0xkgmM8kGXRtU/blOW7XgjATcQUCN2UKrLCecm1JHzJajTeW1sdnURCSKcYDJ63QfiTukdkGsD3RvRWVBcu6iWcllGdV6o8gNMcZfaQGyzelRrjssSx4BUYywvKV2qLwVZaSEhrCbdPj1iYrlADllQUPgKKDYoqmEwNEJiXtjs=
Message-ID: <9a8748490706141618t58082edctd4c166b82eddee97@mail.gmail.com>
Date: Fri, 15 Jun 2007 01:18:34 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Chris Friesen" <cfriesen@nortel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <or8xam87h1.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr> <46718044.1040108@nortel.com>
	 <orodjicpt0.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <200706141848.55378.dhazelton@enter.net>
	 <or8xam87h1.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
[snip]
>
> So what is it that makes hardware so different that it can be used as
> a trick to deny users freedoms, if other tricks can't?
>
[snip]

Why can't you understand that the GPL v2 is a *software* license, it
doesn't cover hardware at all.

If I take some GPLv2 software, modify it and then distribute it on a
CD-ROM and provide the source code as well, then I have complied with
the terms of the license.
If I take the same software, make the same modifications and
distribute the software in a ROM inside some piece of hardware, but
still allow people access to a copy of the source code used to build
whatever I put inside that ROM, then I've also complied with the
license.
In neither case can you modify the copy on the hardware (be it ROM
chip or CD-ROM), but that's not required by the license. As long as
you have access to the source code it's OK. The license says nothing
about you having to be able to update it on the hardware. The license
only says you need access to the source code.

No one is taking away your freedom to change the source or
redistribute it or whatever. The only thing locked hardware prevents
you from doing is installing modified software on that specific piece
of hardware, but that is completely outside the scope of the
*software* license.

[snip]
>
> But then again I ask you: why do you think TiVO is making these
> hardware locks?  What do they want to cause or stop?
>
I can't know for a fact what TiVO wants, but I can guess.

1) Maybe they want to prevent you installing modified software on
their hardware, then contacting them when you break it, costing them
money in customer support etc.

2) Perhaps they don't want to risk being liable if you modify the
software on their box in a way that allows you to use it as a means to
break the law.

3) Maybe they don't want you to modify the software running on their
hardware in such a way as to use the software to obtain intimate
details about their hardware that could be used by a competitor to
create a product superiour to theirs.

All quite valid reasons in my opinion.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
