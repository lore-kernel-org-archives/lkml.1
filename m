Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbXKSQQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbXKSQQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXKSQQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:16:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:49525 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbXKSQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:16:37 -0500
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
From: Daniel Walker <dwalker@mvista.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <3efb10970711190751k2c3ac639r6009b8b56e725650@mail.gmail.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <1195316550.25393.21.camel@imap.mvista.com>
	 <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com>
	 <1195320569.25393.38.camel@imap.mvista.com>
	 <20071117174608.GA30641@elte.hu>
	 <1195322141.25393.41.camel@imap.mvista.com>
	 <1195457078.11545.38.camel@jcmlaptop>
	 <1195486276.25393.65.camel@imap.mvista.com>
	 <3efb10970711190751k2c3ac639r6009b8b56e725650@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 08:11:49 -0800
Message-Id: <1195488709.25393.78.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 16:51 +0100, Remy Bohmer wrote:
> Hello Daniel,
> 
> Can we coordinate who is doing what somehow, to prevent double work?

I actually haven't looked at any on Ingo's list (i8042tregs).. Feel free
to call out the ones your looking at tho..

Daniel

