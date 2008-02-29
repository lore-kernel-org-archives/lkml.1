Return-Path: <linux-kernel-owner+w=401wt.eu-S933355AbYB2UpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbYB2UpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbYB2Uow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:44:52 -0500
Received: from c60.cesmail.net ([216.154.195.49]:29215 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbYB2Uov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:44:51 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20080229201711.GF3234@tuxdriver.com>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv>  <20080229201711.GF3234@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 15:44:48 -0500
Message-Id: <1204317888.2316.19.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 15:17 -0500, John W. Linville wrote:
> On Fri, Feb 29, 2008 at 02:39:38PM -0500, Pavel Roskin wrote:
> 
> > I doubt ndiswrapper will ever be ported to the
> > userspace.  It's much more likely that some other approach will be used.
> 
> Maybe it should be -- that might solve a lot of problems.

I doubt it can be done for PCI due to DMA use by some of the drivers.

Perhaps it could be done for USB, but I doubt anyone will bother.

-- 
Regards,
Pavel Roskin
