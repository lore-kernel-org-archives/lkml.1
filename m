Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYHZCen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYHZCen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 22:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYHZCed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 22:34:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbYHZCec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 22:34:32 -0400
Date: Mon, 25 Aug 2008 22:34:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: objcopy version test for local symbols
In-Reply-To: <20080826115113.806cfe23.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0808252233530.966@gandalf.stny.rr.com>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au> <20080825060934.GB14993@elte.hu> <alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com> <20080825190103.GA24029@elte.hu> <20080826094627.5d627b5b.sfr@canb.auug.org.au>
 <20080826115113.806cfe23.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 26 Aug 2008, Stephen Rothwell wrote:

> Hi Ingo, Steve,
> 
> On Tue, 26 Aug 2008 09:46:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Mon, 25 Aug 2008 21:01:03 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > applied to tip/tracing/ftrace, also have integrated it into 
> > > auto-ftrace-next. (without much testing - i hope it goes well)
> > 
> > Looks ok at a first glance, but it may spam my build logs a bit ...
> > Anyway, we will see.
> 
> I was right, it produces way to many messages :-(

I was afraid of that :-(

> 
> I applied the following patch for now.  It would be nice if this check
> could be done once per build and warned about once as well.

Actually, there is a way. I'll write one up and send it out.

-- Steve

