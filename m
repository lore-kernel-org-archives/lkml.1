Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZBQRJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZBQRJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZBQRJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:09:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZBQRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:09:23 -0500
Date: Tue, 17 Feb 2009 12:09:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 00/15] [git pull] for tip/tracing/ftrace
In-Reply-To: <20090217104213.GC6602@elte.hu>
Message-ID: <alpine.DEB.1.10.0902171207100.910@gandalf.stny.rr.com>
References: <20090217051227.957864159@goodmis.org> <20090217104213.GC6602@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Ingo Molnar wrote:
> 
> Small naming detail: instead of calling it a 'hook' (which 
> really has a bad sound to it for various reasons), how about 
> calling it a 'trigger' and/or a 'callback'?

I started converting the names from hook to trigger, and the name looks 
funny to me. I asked on IRC for opinions and Luis suggested "_probe". I 
think I like that idea.

Ingo, do you agree that "_probe" would be a good substitute for "_hook"?

-- Steve

