Return-Path: <linux-kernel-owner+w=401wt.eu-S2992546AbXCWTxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992546AbXCWTxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934166AbXCWTxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:53:00 -0400
Received: from www.osadl.org ([213.239.205.134]:32814 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934088AbXCWTw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:52:59 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Stephane Casset <sept@logidee.com>,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070323185028.GR752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 21:00:21 +0100
Message-Id: <1174680021.10840.339.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> Subject    : Dynticks and High resolution Timer hanging the system
>              workaround: clocksource=acpi_pm
> References : http://lkml.org/lkml/2007/3/7/504
> Submitter  : Stephane Casset <sept@logidee.com>
> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> Status     : unknown

Stephane, does the problem still exists with Linus latest ?

Thanks,

	tglx


