Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZFMWk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZFMWk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZFMWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:40:20 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:58610 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZFMWkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:40:20 -0400
Subject: Re: perfcounters: lockdep warning
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paulus Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090613194447.GA2616@elte.hu>
References: <1244921989.12341.487.camel@odie.local>
	 <20090613194447.GA2616@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Jun 2009 00:41:43 +0200
Message-Id: <1244932903.19455.283.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lør, 13 06 2009 kl. 21:44 +0200, skrev Ingo Molnar:
> * Simon Holm Thøgersen <odie@cs.aau.dk> wrote:
> 
> > Just tried kicking the tires of performance counters and perf and 
> > got the following warning that doesn't look like have been 
> > reported already.
> 
> Hm, this looks safe at first sight so you can ignore this for now, 
> we'll annotate it properly - thanks for reporting it. Did you see 
> any lockups/problems?

No, everything works well as far as I can tell.


Simon

