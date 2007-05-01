Return-Path: <linux-kernel-owner+w=401wt.eu-S1423598AbXEAO0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423598AbXEAO0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423625AbXEAO0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:26:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:18093 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423598AbXEAO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XVgKwulSvH2sOgqff+ZicgrNMXkeRQGt+NYPfBZ+ouh/HFZdo+tVcd+WNMqyYfAqlZjKW2Nqu5uhaIGQJEBH12yhC3TUr/kVhTsTHamf5l+/doLz3tWG/+Ybb3ZzLiFq5phsn26/6PTc6UESqVxkgDVc1nH1SqygfMiFS4skI+8=
Message-ID: <6bffcb0e0705010726i3408f697qbbeede719445141d@mail.gmail.com>
Date: Tue, 1 May 2007 16:26:09 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
Cc: tglx@linutronix.de, "Daniel Walker" <dwalker@mvista.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <46374B1D.6050509@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46364EBC.5050804@rtr.ca> <463653A3.5040606@rtr.ca>
	 <46367D7E.6060502@rtr.ca> <1177976798.12796.286.camel@imap.mvista.com>
	 <463683A6.4010505@rtr.ca>
	 <1178026458.5791.305.camel@localhost.localdomain>
	 <4637419D.8010303@rtr.ca> <463741F1.7050706@rtr.ca>
	 <1178027285.5791.307.camel@localhost.localdomain>
	 <46374B1D.6050509@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/07, Mark Lord <lkml@rtr.ca> wrote:
> Thomas Gleixner wrote:
> > On Tue, 2007-05-01 at 09:34 -0400, Mark Lord wrote:
> >>> now at 3232363876949 nsecs
> >> ...
> >>
> >> Oh, in case it matters any:
> >> that /proc/timer_list is from the system with CFS-V7 also patched in.
> >
> > It should not. What happens when you disable HPET ?
>
> Booting with clocksource=tsc still hangs in what appears
> to be the exact same place.
>
> Screenshots for that are available here:   http://rtr.ca/hrtimers/

404 Not Found

The requested URL /hrtimers/ was not found on this server.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
