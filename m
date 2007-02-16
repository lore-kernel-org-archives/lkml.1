Return-Path: <linux-kernel-owner+w=401wt.eu-S1161708AbXBPDW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161708AbXBPDW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 22:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161714AbXBPDW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 22:22:58 -0500
Received: from ozlabs.org ([203.10.76.45]:59881 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161708AbXBPDW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 22:22:57 -0500
Subject: Re: [PATCH 9/11] Panic delay fix
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Pavel Machek <pavel@ucw.cz>, Alan <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <45D4F003.4030502@vmware.com>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>
	 <20070207123552.GD4481@ucw.cz>
	 <1170880572.11736.4.camel@localhost.localdomain>
	 <20070214125216.2befda78@localhost.localdomain>
	 <45D36B49.5090109@vmware.com> <20070215101713.GK26240@elf.ucw.cz>
	 <45D4F003.4030502@vmware.com>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 14:22:23 +1100
Message-Id: <1171596143.26672.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 15:42 -0800, Zachary Amsden wrote:
> So Rusty, Chris, Jeremy, any objections to killing udelay() and friends 
> in paravirt-ops?  It would simplify things a bit.

I agree.

Thanks!
Rusty.


