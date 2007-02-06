Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbXBFFL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbXBFFL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXBFFL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:11:56 -0500
Received: from ozlabs.org ([203.10.76.45]:40712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbXBFFLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:11:55 -0500
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <45C809F9.2090905@vmware.com>
References: <200702060352.l163q87K000713@zach-dev.vmware.com>
	 <1170736029.29293.31.camel@localhost.localdomain>
	 <45C809F9.2090905@vmware.com>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 16:11:16 +1100
Message-Id: <1170738676.29293.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 20:54 -0800, Zachary Amsden wrote:
> Rusty Russell wrote:
> > Indeed, I'm expecting to push lguest this week, and this code will
> > effect me, so I'd like to see this in a -mm soon...
> 
> Yes, I took a look at the lguest changes today and I think these won't 
> generate conflicts, just make stuff easier for you ;)  Course you've now 
> got a couple new paravirt-ops to support, but the native ones are fine 
> for temporary use.

Implementing stolen time is something I'd like to do, since it'd be a
nice self-contained example the expectations.

Patches welcome (but note that I've started a new lguest patch repo at
http://lguest.kernel.org/patches).

Thanks!
Rusty.


