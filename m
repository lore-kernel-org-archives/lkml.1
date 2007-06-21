Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXFUGjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXFUGjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXFUGjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:39:44 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56713
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXFUGjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:39:43 -0400
Date: Wed, 20 Jun 2007 23:39:03 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Andrew McKay <amckay@iders.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br> <4673CA7C.5040207@t-online.de>
 <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616181902.GB21478@ftp.linux.org.uk>
 <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca>
 <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca>
 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
 <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
 <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Alexandre Oliva wrote:

> On Jun 21, 2007, david@lang.hm wrote:
>
>> how exactly can they prevent a system that's been tampered with from
>> accessing their network?
>
> By denying access to their servers?  By not granting whatever is
> needed to initiate network sessions?
>
> And note, "it's been tampered with" is not necessarily enough of a
> reason to cut someone off, it has to meet these requirements:

how can the server tell if it's been tampered with?

>>   when the modification itself materially and adversely affects the
>>   operation of the network or violates the rules and protocols for
>>   communication across the network.
>
>> (something even you say they have a right to do)
>
> as long as this right is not used by the software distributor to
> impose restrictions on the user's ability to adapt the software to
> their own needs.  The GPLv3 paragraph above makes a fair concession in
> this regard, don't you agree?

no, one of the rules for the network is that the software must be 
certified, you are requireing the device to permit the software to be 
changed to an uncertified version.(to store credit card numbers and send 
them to a third party for example)

David Lang
