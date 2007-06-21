Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbXFUPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbXFUPTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXFUPTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:19:08 -0400
Received: from gateway12.iders.ca ([206.45.72.61]:57241 "EHLO koko.iders.ca"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbXFUPTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:19:07 -0400
Message-ID: <467A96DC.1020906@iders.ca>
Date: Thu, 21 Jun 2007 10:18:52 -0500
From: Andrew McKay <amckay@iders.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: david@lang.hm
CC: Alexandre Oliva <aoliva@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <4673CA7C.5040207@t-online.de> <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616181902.GB21478@ftp.linux.org.uk> <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org> <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org> <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org> <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca> <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca> <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm> <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm> <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Thu, 21 Jun 2007, Alexandre Oliva wrote:
> 
>> On Jun 21, 2007, david@lang.hm wrote:
>>
>>> how exactly can they prevent a system that's been tampered with from
>>> accessing their network?
>>
>> By denying access to their servers?  By not granting whatever is
>> needed to initiate network sessions?
>>
>> And note, "it's been tampered with" is not necessarily enough of a
>> reason to cut someone off, it has to meet these requirements:
> 
> how can the server tell if it's been tampered with?
> 

I agree with this statement.  Imagine a proprietary private network where a 
device has been modified to run in an invisible promiscuous mode.  The device 
looks as if it isn't doing anything wrong, but is forwarding the network out 
another interface.  The only way to prevent that type of attack is to not allow 
unauthorized signed Kernels onto that network.

Andrew McKay
