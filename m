Return-Path: <linux-kernel-owner+w=401wt.eu-S2992586AbXCWV6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992586AbXCWV6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992587AbXCWV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:58:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40937 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992586AbXCWV6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:58:10 -0400
Date: Fri, 23 Mar 2007 14:54:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Tracy <rct@gherkin.frus.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
In-Reply-To: <1174686238.5690.5.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703231453510.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> 
 <20070323185028.GR752@stusta.de> <1174686238.5690.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 Mar 2007, john stultz wrote:
> 
> The incorrect clocksource selection is resolved w/ this patch:
> http://lkml.org/lkml/2007/3/22/287
> 
> There is still an issue of why the PIT clocksource hangs, but for the
> moment the issue its worked-around.

Hmm.. I haven't seen it until now. Is it waiting for something?

		Linus
