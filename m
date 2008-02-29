Return-Path: <linux-kernel-owner+w=401wt.eu-S933956AbYB2WSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbYB2WSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYB2WR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:17:57 -0500
Received: from c60.cesmail.net ([216.154.195.49]:58802 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbYB2WR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:17:56 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to
	use	GPL-only	symbols
From: Pavel Roskin <proski@gnu.org>
To: David Newall <davidn@davidnewall.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <47C87460.2030705@davidnewall.com>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv> <20080229201711.GF3234@tuxdriver.com>
	 <47C86DCA.5080706@davidnewall.com> <1204318797.2316.29.camel@dv>
	 <47C87460.2030705@davidnewall.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 17:17:53 -0500
Message-Id: <1204323473.2316.59.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-01 at 07:38 +1030, David Newall wrote:

> I think there's a political agenda, and that's something that nobody can
> solve.  The simplest solution is to change the name it uses on a regular
> basis, and that something relatively  unimportant.  People will still
> call it ndiswrapper, but it will identify itself to the kernel as
> wrappythingy, and then ndisthingy, and then wrapndis.  Heck, make it
> purely random.  Solve the problem for all time.

If there is a political agenda, then LKML is the worst place to discuss
the details.

> It's a stupid problem promulgated by stupid people, and I use the word
> "stupid" in it's most pejorative sense.

It would be more useful if you counter specific arguments rather than
employ ad hominem attacks.

-- 
Regards,
Pavel Roskin
