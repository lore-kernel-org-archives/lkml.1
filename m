Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYEEQb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYEEQb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYEEQbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:31:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:40726 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbYEEQbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:31:18 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.58.0805051220590.25250@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
	 <1209753250.25628.34.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>
	 <1210004250.17132.12.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051220590.25250@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 05 May 2008 09:31:13 -0700
Message-Id: <1210005073.17132.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 12:21 -0400, Steven Rostedt wrote:
> On Mon, 5 May 2008, Daniel Walker wrote:
> > You really want bisection first. The reason is that you don't want ever
> > growing patches, you want smaller and smaller patches. For instance the
> > rt-mutex-core.patch is way too large, you wouldn't want to fold my
> > PICK_FUNCTION changes into that patch since that would just make
> > rt-mutex-core larger ..
> >
> 
> Yeah, I already did that ;-)

You already folded my PICK_FUNCTION changes? That's why I mentioned it.

Daniel

