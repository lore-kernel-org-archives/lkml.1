Return-Path: <linux-kernel-owner+w=401wt.eu-S965763AbXCLMXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbXCLMXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 08:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965760AbXCLMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 08:23:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:41758 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965763AbXCLMXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 08:23:34 -0400
Date: Mon, 12 Mar 2007 15:23:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070312122305.GB107@tv-sign.ru>
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703121219.12072.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Rafael J. Wysocki wrote:
> 
> On Monday, 12 March 2007 09:14, Pavel Machek wrote:
> > 
> > Can we get better name for this function?
> 
> Well, I took the name from the Oleg's message.  Can you please suggest
> something?

Well, kthread_should_stop_check_freeze() is really awful, I agree :)
We need something better, but I can't suggest anything.

Oleg.

