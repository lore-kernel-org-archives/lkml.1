Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbXFSORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbXFSORj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXFSORb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:17:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:15888 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbXFSORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J4x2mtmWx2BtUYFdNY/nJbJh7De4wraw5701GUq7K9IvQvQPK2vPNi/k4D4dszYfRB7XWrBLaSKqMIVIUq8cXjNzIUTXCBz+ue85I3KnN0dJEoTPHHqX782sSS3jfvaATD4R72MkXHaASFaBhHKp6QQEHg4cFHA2F6N4UlxOFYs=
Message-ID: <84144f020706190717q33dbc5e0r5d33b550aa22bfb3@mail.gmail.com>
Date: Tue, 19 Jun 2007 17:17:30 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <or7iq05w6g.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <200706181945.16343.dhazelton@enter.net>
	 <orvedk8zpa.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706182035420.3593@woody.linux-foundation.org>
	 <or7iq05w6g.fsf@oliva.athome.lsd.ic.unicamp.br>
X-Google-Sender-Auth: eb439499284a0034
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On 6/19/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> Dispute this:
>
> non-tivoized hardware => users can scratch their itches => more
> contributions from these users
>
> tivoized hardware => users can't scratch their itches => fewer
> contributions from these users

Maybe, but in what numbers? It's not like every user out there is able
to scratch their itches in the first place. Besides, people who want
to hack their hardware either work around the restrictions (like Linux
on xbox) or buy hardware that doesn't have any.

In any case, I hope we call quits on this thread. People have already
explained to you that there are certain devices (ATMs, medical
equipment) where you absolutely want "tivoization". Furthermore, Linus
has repeatedly explained to you why he (and bunch of other _kernel_
hackers -- this is a thread on LKML, remember) thinks it's stupid for
a software license to restrict hardware design choices. If you don't
see the point, fine, but lets stop wasting each others time, ok?
