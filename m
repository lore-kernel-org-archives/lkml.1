Return-Path: <linux-kernel-owner+w=401wt.eu-S1764807AbXGTOKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764807AbXGTOKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760640AbXGTOJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:09:58 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52584 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXGTOJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:09:58 -0400
Date: Fri, 20 Jul 2007 10:09:06 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under	arch-level Virtualization option
Message-ID: <20070720140906.GB6534@c2.user-mode-linux.org>
References: <1184905342.10380.263.camel@localhost.localdomain> <46A046F1.7040207@qumranet.com> <1184911347.10380.274.camel@localhost.localdomain> <46A051EE.7060304@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A051EE.7060304@vmware.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 11:10:54PM -0700, Zachary Amsden wrote:
> I'm rather indifferent on the matter, but I think a virtualization menu 
> under UML would be very confusing.

Yeah, that would be interesting.  Trying to get one menu, with
switches that the arch can turn on and off, seems to make sense if you
can get away without too many switches.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
