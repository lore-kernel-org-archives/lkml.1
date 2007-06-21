Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbXFUKTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbXFUKTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 06:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXFUKSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 06:18:52 -0400
Received: from srv1.netkinetics.net ([206.71.148.180]:33048 "EHLO
	srv1.netkinetics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXFUKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 06:18:51 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: Tim Post <tim.post@netkinetics.net>
Reply-To: tim.post@netkinetics.net
To: david@lang.hm
Cc: Alexandre Oliva <aoliva@redhat.com>, Andrew McKay <amckay@iders.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070615012623.GA25189@elte.hu>
	 <20070615101007.0cbfd078@the-village.bc.nu>
	 <orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <4673CA7C.5040207@t-online.de>
	 <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070616181902.GB21478@ftp.linux.org.uk>
	 <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca>
	 <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca>
	 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
	 <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
Content-Type: text/plain
Organization: Net Kinetics
Date: Thu, 21 Jun 2007 18:15:36 +0800
Message-Id: <1182420936.9012.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv1.netkinetics.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - netkinetics.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 22:30 -0700, david@lang.hm wrote:

> 
> asking a device that's running software that you haven't verified to give 
> you a checksum of itself isn't going to work becouse the software can just 
> lie to you.
> 

I don't think there is any way I _could_ make a device if it had to be
tamper proof and use free software if that was the case. 

I'd need to make some kind of proprietary network connection back to my
company that used its own network device. I could not trust it if the
free kernel could touch it, if I wanted to allow a modified in place
kernel.

If I hope for that device to use the internet to talk to me (i.e. just a
secondary nic), I'd have to write my own kernel to power this second
network device that was capable of encrypting and validating traffic
over tcp-ip. Or I have to pull my own copper to every location where my
device is used.

So either way, I'm writing my own kernel if I want to do that, because I
could not POSSIBLY allow the kernel talking to my private connection to
the device to be modified. 

What a nasty, vicious cycle that would be. Yikes!
 

--Tim


