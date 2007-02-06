Return-Path: <linux-kernel-owner+w=401wt.eu-S1030571AbXBFX26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030571AbXBFX26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030569AbXBFX25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:28:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:53346 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030571AbXBFX2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:28:41 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <200702061815.41078.rob@landley.net>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170793206.3785.16.camel@chaos> <1170794437.3455.20.camel@dwalker1>
	 <200702061815.41078.rob@landley.net>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 15:28:38 -0800
Message-Id: <1170804518.3455.115.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 18:15 -0500, Rob Landley wrote:
> On Tuesday 06 February 2007 3:40 pm, Daniel Walker wrote:
> > In this case "different" goes into userspace .. So different could mean
> > userspace regression, which is something that we don't want. I have no
> > idea if any apps use /proc/interrupts , but it's possible since it's
> > been around for a long time.
> > 
> > The reason that I'm bringing it up at all is because people have ask me
> > "Why isn't my timer ticking??"
> 
> Because there are two clock sources in the machine and it's using the other 
> one, so the interrupt isn't firing?
> 
> Are you saying that the /proc statistics aren't accurate, or that you 
> previously misunderstood what it was actually measuring and you'd now like it 
> to lie?

I understand exactly what is happening . The statistics are unclear, and
tend to confuse people .

Daniel

