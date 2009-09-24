Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZIXVUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZIXVUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZIXVUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:20:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1180 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZIXVUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:20:06 -0400
Subject: Re: [PATCH] hrtimer: Remove overly verbose "switch to high res
 mode" message
From: Joe Perches <joe@perches.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <adaws3oyrh9.fsf@cisco.com>
References: <adavdj92sso.fsf@cisco.com> <adar5tx2s9d.fsf@cisco.com>
	 <20090924093800.GA23158@elte.hu> <ada1vlw126s.fsf_-_@cisco.com>
	 <1253826764.1806.24.camel@Joe-Laptop.home>  <adaws3oyrh9.fsf@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Sep 2009 14:20:10 -0700
Message-Id: <1253827210.1806.27.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 14:15 -0700, Roland Dreier wrote:
> > > -	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
>  > > -	       smp_processor_id());
>  > Perhaps pr_debug instead?
> Dunno... is that kernel log message ever useful now?

Dunno either.
I think lots of kernel log messages are not particularly useful.
Others frequently think different...

cheers, Joe

