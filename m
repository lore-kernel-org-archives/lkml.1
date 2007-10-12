Return-Path: <linux-kernel-owner+w=401wt.eu-S1761205AbXJLXQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761205AbXJLXQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762023AbXJLW5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:57:10 -0400
Received: from [212.12.190.36] ([212.12.190.36]:48176 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761759AbXJLW5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:57:01 -0400
From: Al Boldi <a1426z@gawab.com>
To: Patrick McHardy <kaber@trash.net>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
Date: Sat, 13 Oct 2007 01:56:54 +0300
User-Agent: KMail/1.5
Cc: Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-net@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200710120031.42805.a1426z@gawab.com> <Pine.LNX.4.64.0710121533360.23981@fbirervta.pbzchgretzou.qr> <470F7B4B.2010609@trash.net>
In-Reply-To: <470F7B4B.2010609@trash.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200710130156.54050.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Jan Engelhardt wrote:
> > On Oct 12 2007 16:30, Al Boldi wrote:
> >>>>With the existence of the mangle table, how useful is the filter
> >>>> table?
> >>>
> >>>A similar discussion was back in March 2007.
> >>>http://marc.info/?l=netfilter-devel&m=117394977210823&w=2
> >>>http://marc.info/?l=netfilter-devel&m=117400063907706&w=2
> >>>
> >>>in the end, my proposal was something like
> >>>http://jengelh.hopto.org/GFX0/nf_proposal2.svg
> >>
> >>Any chance you could publish this as something readable like text/html?
> >
> > Like, image/png?
> > http://jengelh.hopto.org/GFX0/nf_proposal2.png
>
> The netlink based iptables successor I'm currently working on allows to
> dynamically create tables with user-specified priorities and "built-in"
> chains. The only built-in tables will be those that need extra
> processing (mangle/nat). So it should be possible to set up tables
> basically any way you desire.

Wow!  How soon can we expect this to surface on mainline?


Thanks a lot!

--
Al
