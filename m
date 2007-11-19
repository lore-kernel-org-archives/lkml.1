Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbXKSPgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbXKSPgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXKSPgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:36:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:36039 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXKSPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:36:34 -0500
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
From: Daniel Walker <dwalker@mvista.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Ingo Molnar <mingo@elte.hu>, Remy Bohmer <linux@bohmer.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1195457078.11545.38.camel@jcmlaptop>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <1195316550.25393.21.camel@imap.mvista.com>
	 <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com>
	 <1195320569.25393.38.camel@imap.mvista.com>
	 <20071117174608.GA30641@elte.hu>
	 <1195322141.25393.41.camel@imap.mvista.com>
	 <1195457078.11545.38.camel@jcmlaptop>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 07:31:16 -0800
Message-Id: <1195486276.25393.65.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 02:24 -0500, Jon Masters wrote:
> On Sat, 2007-11-17 at 09:55 -0800, Daniel Walker wrote:
> 
> > Sure, you want to split the list?
> 
> I'm happy to grab a few of these too. Let me know if either of you or
> Ingo is working on the whole lot and about to dump it on us ;-)

I was planning to just try a few, so I think your safe.. 

Daniel

