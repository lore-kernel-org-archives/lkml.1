Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbXFTTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbXFTTNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbXFTTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:13:25 -0400
Received: from gateway12.iders.ca ([206.45.72.61]:56387 "EHLO koko.iders.ca"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbXFTTNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:13:24 -0400
Message-ID: <46797C52.4020907@iders.ca>
Date: Wed, 20 Jun 2007 14:13:22 -0500
From: Andrew McKay <amckay@iders.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070614195517.GA4933@elte.hu>	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070614235004.GA14952@elte.hu>	<20070615011012.6c09066e@the-village.bc.nu>	<20070615012623.GA25189@elte.hu>	<20070615101007.0cbfd078@the-village.bc.nu>	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>	<4673CA7C.5040207@t-online.de>	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070616181902.GB21478@ftp.linux.org.uk>	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>	<4679557C.5080907@iders.ca> <20070620175627.319a6c55@the-village.bc.nu>
In-Reply-To: <20070620175627.319a6c55@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Secondly GPLv3 will cause companies like TIVO, router companies, security 
>> companies to not adopt Linux as an operating system, because they can't secure 
>> their system.  Placing code in a ROM so they can't upgrade their own systems is 
> 
> You've made an important mistake. You said "their system". Now its "our
> code" and "whoever bought the units' hardware" so it isn't their anything.


Yes, the hardware belongs to the user, and the software belongs to the Linux 
community.   However I think I wasn't 100% clear, I also mean keeping companies 
networks and content secured.  Credit card companies insuring the software 
hasn't been modified to skim cards (not that it's the only way to skim a card), 
  or Tivo making sure that their content providers are protected.  Lets look at 
the credit card example.  Sure the user could modify the system and boot their 
own kernel, but it doesn't have to play nice with Mastercard's network anymore. 
  Or better yet, would actually report that a certain business's card reader had 
been tampered with.

> 
> You've made a second mistake I think by assuming that vendor held keys
> "improve" security and must be vendor held and secret for it to work. In
> fact vendor owned key systems that cannot be changed usually reduce
> security.
> 
> There are very very good reasons for having vendor owned secret keys.
> There are also very very good reasons for being able to rekey or disable
> the key on your box.
> 
> Ask people whose product vendor went bankrupt. With the ability to
> override/replace the keys they could have maintained their system
> securely instead they could make no updates and the boxes were left
> insecure.

I do see what you're saying here, and I can see how this is a problem.  However 
what is the solution?  Sure having the system open for users to replace software 
and tinker is great.  It's how I got into engineering.  I can also appreciate 
the ability for the end user to fix and continue to use a system long after a 
vendor goes out of business.  However, I don't see how this would ever require a 
company like Tivo or Mastercard to have their networks play nice with a unit 
that has been modified by the end user, potentially opening up some serious 
security holes.  From what I understand this would still violate GPLv3 because 
the system could no longer preform the task it was designed to do with modified 
code, but maybe I have misunderstood.

Andrew McKay

