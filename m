Return-Path: <linux-kernel-owner+w=401wt.eu-S1946521AbXBIPYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946521AbXBIPYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946523AbXBIPYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:24:06 -0500
Received: from ozlabs.org ([203.10.76.45]:47973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946521AbXBIPYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:24:05 -0500
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@muc.de>, virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070209141728.GA26749@uranus.ravnborg.org>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012761.2718.40.camel@localhost.localdomain>
	 <1171012827.2718.42.camel@localhost.localdomain>
	 <200702091109.20061.ak@muc.de>
	 <1171024771.2718.129.camel@localhost.localdomain>
	 <20070209141728.GA26749@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 02:23:19 +1100
Message-Id: <1171034599.2718.190.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 15:17 +0100, Sam Ravnborg wrote:
> I do not quite see what you ask for.
> Care to try to describe the problem a bit then I may look at it sometime.
> 
> [Heading for vacation in a few hours so no prompt reply]

I'd like my own, private "asm-offsets.h".  In this case, in
arch/i386/lguest/.  I guess it's a matter of extracting the core of the
asm-offsets.h magic and generalizing it.

Have a good break!
Rusty.


