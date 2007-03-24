Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbXCXAoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbXCXAoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXCXAoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:44:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33594 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXCXAoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:44:14 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: john stultz <johnstul@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Tracy <rct@gherkin.frus.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0703231453510.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174686238.5690.5.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703231453510.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 17:44:11 -0700
Message-Id: <1174697051.5690.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 14:54 -0700, Linus Torvalds wrote:
> 
> On Fri, 23 Mar 2007, john stultz wrote:
> > 
> > The incorrect clocksource selection is resolved w/ this patch:
> > http://lkml.org/lkml/2007/3/22/287
> > 
> > There is still an issue of why the PIT clocksource hangs, but for the
> > moment the issue its worked-around.
> 
> Hmm.. I haven't seen it until now. Is it waiting for something?

Not really. Just waiting for Andrew to pick it up and push it on.

thanks
-john

