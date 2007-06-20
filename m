Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXFTVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXFTVlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXFTVlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:41:09 -0400
Received: from gateway12.iders.ca ([206.45.72.61]:56490 "EHLO koko.iders.ca"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXFTVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:41:08 -0400
Message-ID: <46799EEF.7030403@iders.ca>
Date: Wed, 20 Jun 2007 16:41:03 -0500
From: Andrew McKay <amckay@iders.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alexandre Oliva <aoliva@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070614195517.GA4933@elte.hu>	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070614235004.GA14952@elte.hu>	<20070615011012.6c09066e@the-village.bc.nu>	<20070615012623.GA25189@elte.hu>	<20070615101007.0cbfd078@the-village.bc.nu>	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>	<4673CA7C.5040207@t-online.de>	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070616181902.GB21478@ftp.linux.org.uk>	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>	<4679557C.5080907@iders.ca>	<20070620175627.319a6c55@the-village.bc.nu>	<46797C52.4020907@iders.ca> <orodjatk8x.fsf@oliva.athome.lsd.ic.unic
 amp.br>
In-Reply-To: <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Oliva wrote:
> On Jun 20, 2007, Andrew McKay <amckay@iders.ca> wrote:
> 
>> However, I don't see how this would ever require a company like Tivo
>> or Mastercard to have their networks play nice with a unit that has
>> been modified by the end user, potentially opening up some serious
>> security holes.
> 
> Which is why the GPLv3 doesn't make the requirement that you stated.
> 

So if it's not a requirement of the GPLv3, then Tivo could deny content based 
signing the binary image of the Linux kernel and using that signature as 
authentication on their network (or their content providers network).  A 
modified Tivo box would not be able to preform it's original task of being a PVR 
at that point, at least with the content provider's signal.  Seems pretty 
pointless to me.  Seems like almost the same thing as not allowing an unsigned 
Linux kernel to boot on the system.  Though it would still be possible to get 
the Tivo box to play tetris or something like that.

Andrew McKay

