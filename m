Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXCWTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXCWTOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXCWTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:14:43 -0400
Received: from www.osadl.org ([213.239.205.134]:38616 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753399AbXCWTOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:14:41 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>
In-Reply-To: <20070323185028.GR752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 20:22:03 +0100
Message-Id: <1174677724.10840.328.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> Subject    : dynticks makes ksoftirqd1 use unreasonable amount of cpu time
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8100
> Submitter  : Emil Karlson <jkarlson@cc.hut.fi>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged

The problem is not reproducible on any of my machines.

Emil, is it still there with Linus latest ?

	tglx


