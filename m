Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbXIRVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbXIRVf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXIRVfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:35:17 -0400
Received: from ozlabs.org ([203.10.76.45]:37830 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbXIRVfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:35:16 -0400
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: virtualization@lists.linux-foundation.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <200709181257.41530.ak@suse.de>
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <1189747124.7262.36.camel@localhost.localdomain>
	 <1189747280.7262.39.camel@localhost.localdomain>
	 <200709181257.41530.ak@suse.de>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 07:34:32 +1000
Message-Id: <1190151272.7262.175.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 12:57 +0200, Andi Kleen wrote:
> On Friday 14 September 2007 07:21, Rusty Russell wrote:
> > It's pretty widely used,
> 
> Is it? By whom?

Hi Andi,

	Please stop asking for facts!  It's was easy claim to make, and hard to
disprove 8)

> > and the distributions will turn it on. 
> 
> That's no reason to make it default y. Please undo that. default y
> is near always a bad idea.

How about a "select" based on Xen, lguest or VMI?  There's no other
reason to enable it, after all.

> Also I would still consider it experimental.

After 9 months in mainline and three kernel versions, I'd hope not.
It's been pretty damn stable (ok, you broke it once, but maybe that's
because you consider it experimental).

Cheers,
Rusty.

