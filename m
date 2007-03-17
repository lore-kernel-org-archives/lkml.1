Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXCRArI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXCRArI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXCRArI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:47:08 -0400
Received: from ozlabs.org ([203.10.76.45]:32915 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbXCRArF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:47:05 -0400
Subject: Re: [patch 05/26] Xen-paravirt_ops: paravirt_ops: hooks to set up
	initial pagetable
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <45FAE46F.7080009@goop.org>
References: <20070301232443.195603797@goop.org>
	 <20070301232526.611972133@goop.org> <20070316093348.GS23174@elte.hu>
	 <45FAE46F.7080009@goop.org>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 20:47:29 +1100
Message-Id: <1174124849.8897.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 11:39 -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> >> +	/* Make sure kernel address space is empty so that a pagetable
> >> +	   will be allocated for it. */
> >>     
> >
> > comment style.
> >   
> 
> As you've noticed its a comment style I use quite often.

Me too, and Ingo and I have had this argument before.  These days I try
hard to fit simple comments in a single line 8)

Rusty.


