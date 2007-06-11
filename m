Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbXFKT65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbXFKT65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbXFKT6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:58:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:44543 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbXFKT6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:58:49 -0400
Subject: Re: 2.6.21-rt2..8 troubles
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1181591122.8176.159.camel@chaos>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
	 <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>
	 <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos>
	 <4658A4F4.1080204@rncbc.org>  <46660369.2070104@rncbc.org>
	 <1181317625.4404.332.camel@chaos>
	 <59605.213.13.107.141.1181326897.squirrel@www.rncbc.org>
	 <1181328636.4404.335.camel@chaos>  <466DA42A.6010600@rncbc.org>
	 <1181591122.8176.159.camel@chaos>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 12:55:33 -0700
Message-Id: <1181591733.11539.217.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 21:45 +0200, Thomas Gleixner wrote:
> On Mon, 2007-06-11 at 20:36 +0100, Rui Nuno Capela wrote:
> > > I'm spinning -rt10 with a couple of fixes. Should be out sometimes
> > > tomorrow. If the problem persists, we need to dig deeper.
> > > 
> > 
> > Uhoh. I'm sorry to tell, but the problem is still creeping on
> > 2.6.21.4-rt11 and -rt12 :(
> > 
> > So sorry.
> 
> Hmm. Does it happen, when you boot with maxcpus=1 on the kernel
> commandline ?

I think 2.6.21-rt2 had some apic updates also, (along with hpet updates)
so testing with "noapic" on the command line might be helpful too .. 

Daniel

