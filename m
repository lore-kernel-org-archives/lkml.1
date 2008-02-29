Return-Path: <linux-kernel-owner+w=401wt.eu-S933477AbYB2Udw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477AbYB2Udw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbYB2Udn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:33:43 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3674 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbYB2Udn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:33:43 -0500
Date: Fri, 29 Feb 2008 15:17:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080229201711.GF3234@tuxdriver.com>
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <1204304352.6767.21.camel@localhost> <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204313978.2316.8.camel@dv>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 02:39:38PM -0500, Pavel Roskin wrote:

> I doubt ndiswrapper will ever be ported to the
> userspace.  It's much more likely that some other approach will be used.

Maybe it should be -- that might solve a lot of problems.

-- 
John W. Linville
linville@tuxdriver.com
