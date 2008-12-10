Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYLJRti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYLJRti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYLJRrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:47:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbYLJRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:47:39 -0500
Date: Wed, 10 Dec 2008 12:47:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH][RT] Compile-time fix.
In-Reply-To: <493FED0D.4080204@novell.com>
Message-ID: <alpine.DEB.1.10.0812101247220.11248@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com>  <1228890920.9542.2.camel@dd> <1228892002.9542.4.camel@dd> <alpine.DEB.1.10.0812100643130.5912@gandalf.stny.rr.com> <493FED0D.4080204@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Dec 2008, Gregory Haskins wrote:

> Steven Rostedt wrote:
> >
> > If you do want to help, look at any of the other branches. Some have not 
> > been updated yet, and they all should be able to compile and boot on their 
> > own. If they do not, then those need to be fixed.
> >   
> 
> A good place to start for some low-hanging fruit would be rt/workqueue. 
> I ported the patches, but it doesn't yet boot (assuming Steve merged the
> work I had done...I havent looked recently).  I think its a relatively
> trivial problem, but I have not had a chance to track it down yet.

I have not pulled it yet, I'll do it now.

-- Steve

