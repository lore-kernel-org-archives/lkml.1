Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbXEJIvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbXEJIvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXEJIu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:50:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757562AbXEJIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:50:58 -0400
Date: Thu, 10 May 2007 01:50:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
Message-Id: <20070510015036.ebded3ac.akpm@linux-foundation.org>
In-Reply-To: <1178786505.14928.225.camel@localhost.localdomain>
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
	<20070509224113.cca81a24.akpm@linux-foundation.org>
	<1178778951.14928.215.camel@localhost.localdomain>
	<20070510003528.395b122b.akpm@linux-foundation.org>
	<1178786505.14928.225.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 18:41:45 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > > What about my comment layout style ? I've been using that forever ... Or
> > > do you mean I should use a function documentation style layout there ?
> > 
> > /* This
> >  * is
> >  * wrong
> >  */
> > 
> > /*
> >  * This
> >  * is
> >  * right
> >  */
> 
> Hrm... how bad are you about that one ? I must say I prefer my style :-)
> 

I usually shrug and ignore it.  It's more a matter of informing people
about it than going in there and fixing them all.

We discussed this a couple of months back.  davem landed firmly in the
second camp and everyone then shut up ;)

