Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbXFSEyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbXFSEyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 00:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXFSExy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 00:53:54 -0400
Received: from srv1.netkinetics.net ([206.71.148.180]:38026 "EHLO
	srv1.netkinetics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXFSExx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 00:53:53 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: Tim Post <tim.post@netkinetics.net>
Reply-To: tim.post@netkinetics.net
To: Daniel Drake <dsd@gentoo.org>
Cc: Alexandre Oliva <aoliva@redhat.com>, Bron Gondwana <brong@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46774BD3.6010605@gentoo.org>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
	 <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070615072322.GA7594@brong.net>
	 <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070616021630.GA30660@brong.net>
	 <orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070616103130.GD32405@brong.net>
	 <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070616233251.GA17270@brong.net>
	 <ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <46774BD3.6010605@gentoo.org>
Content-Type: text/plain
Organization: Net Kinetics
Date: Tue, 19 Jun 2007 12:51:19 +0800
Message-Id: <1182228679.21798.1711.camel@localhost.localdomain>
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

On Mon, 2007-06-18 at 23:21 -0400, Daniel Drake wrote:
> Let's take a certain class of medical devices into account: ones that 
> are absolutely definitely for medical treatment, but are not life 
> threatening if they fail.
> 
> Say, a dental treatment device -- if the device produces a crown or 
> bridge that doesn't fit properly, the dentist says "nope" and throws it 
> away. No harm done.

I've done quite a bit of research, I'm not nearly done.

These regulations (from what I can tell) seemed to follow suit with the
National Electric Code (NEC) [latest] when dealing with mandatory
isolated ground devices and special cabling methods when it comes into a
device touching a patient. If that remains consistent, this won't be so
bad.

If the patient never comes in contact with it, its not regulated as much
and (from what I've seen) has no requirement for tamper proofing. I
point out again, I am not _nearly_ done with my research.

I think of nothing else, anyone with an interest should closely monitor
how these devices are being regulated by the FDA as more of them begin
to look like penguins.

I won't argue one way or another as to the presence of benevolent intent
in those laws-to-come, I'm simply pointing out the questionable
technical competency of those who will be writing them and their need
for guidance when doing so.


Best,
--Tim


