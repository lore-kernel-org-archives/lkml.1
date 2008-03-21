Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYCUSLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYCUSLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759939AbYCUSLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:11:23 -0400
Received: from h155.mvista.com ([63.81.120.158]:45844 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759495AbYCUSLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:11:22 -0400
Subject: Re: [PATCH -rt] rt-slab: fix cpu inconsistency case
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com>
References: <47E2A63B.4020003@ct.jp.nec.com>
	 <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 11:11:17 -0700
Message-Id: <1206123077.10894.221.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-20 at 15:32 -0400, Steven Rostedt wrote:
> And these are the PREEMPT_RT version. So basically, this patch is a
> nop
> for PREEMPT_RT. I doubt it will solve your bug ;-)


He said it was a !PREEMPT_RT issue (in the -rt tree) ..

Daniel

