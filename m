Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbXEJImR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbXEJImR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbXEJImE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:42:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:41890 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXEJImC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:42:02 -0400
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20070510003528.395b122b.akpm@linux-foundation.org>
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
	 <20070509224113.cca81a24.akpm@linux-foundation.org>
	 <1178778951.14928.215.camel@localhost.localdomain>
	 <20070510003528.395b122b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 18:41:45 +1000
Message-Id: <1178786505.14928.225.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > What about my comment layout style ? I've been using that forever ... Or
> > do you mean I should use a function documentation style layout there ?
> 
> /* This
>  * is
>  * wrong
>  */
> 
> /*
>  * This
>  * is
>  * right
>  */

Hrm... how bad are you about that one ? I must say I prefer my style :-)

Cheers,
Ben.

