Return-Path: <linux-kernel-owner+w=401wt.eu-S935105AbXGMGKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935105AbXGMGKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933043AbXGMGKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:10:01 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:22250 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXGMGKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:10:00 -0400
X-IronPort-AV: i="4.16,535,1175486400"; 
   d="scan'208"; a="45363552:sNHT30723371"
Subject: Re: Linux 2.6.22.1
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
In-Reply-To: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 13 Jul 2007 14:16:20 +0800
Message-Id: <1184307380.8943.7.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 13 Jul 2007 06:09:58.0771 (UTC) FILETIME=[70E96430:01C7C514]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 02:35 +0800, Nish Aravamudan wrote:
> On 7/10/07, Greg KH <greg@kroah.com> wrote: 
> > We (the -stable team) are announcing the release of the 2.6.22.1
> kernel. 
> > It contains a security fix for SCTP that somehow forgot to be added
> to 
> > the 2.6.22 kernel (was already released in the 2.6.21.y releases). 
> > Thanks to Patrick McHardy for noticing the mistake. 
> > 
> > I'll also be replying to this message with a copy of the patch
> between 
> > 2.6.22 and 2.6.22.1 
> > 
> > The updated 2.6.22.y git tree can be found at: 
> >
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
> 
> Can you please also update
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> 
> ? Maybe make that update part of whatever process you use to push out 
> the 2.6.Y trees, as I've had to ask for this more than once now?
> 

Could you please open http:// git-pull? I was blocked by company's
firewall except http method -:((.

Thanks a lot
-Bryan Wu
