Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbXKSP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbXKSP60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXKSP6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:58:19 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:21459 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbXKSP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:58:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ig0p5jtqmqVgevtW61mgP6tCStXjealRX4UP/JIFztfMFRRkxCe07+wtr9z3+LR0HTu0GFjH0K8GHPXwF0xrutKnZlkC9y5Tg3BQxDd/5VdZWwSHIemMJmUeYuAECl/Uclt4PYBzYAlsRVOVb/MKeueI6PKcTqpUfF9nLZH4xAs=
Message-ID: <3efb10970711190751k2c3ac639r6009b8b56e725650@mail.gmail.com>
Date: Mon, 19 Nov 2007 16:51:39 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
Cc: "Jon Masters" <jonathan@jonmasters.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1195486276.25393.65.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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
X-Google-Sender-Auth: c71b3407baea8dbf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

Can we coordinate who is doing what somehow, to prevent double work?

Remy

2007/11/19, Daniel Walker <dwalker@mvista.com>:
> On Mon, 2007-11-19 at 02:24 -0500, Jon Masters wrote:
> > On Sat, 2007-11-17 at 09:55 -0800, Daniel Walker wrote:
> >
> > > Sure, you want to split the list?
> >
> > I'm happy to grab a few of these too. Let me know if either of you or
> > Ingo is working on the whole lot and about to dump it on us ;-)
>
> I was planning to just try a few, so I think your safe..
>
> Daniel
>
>
