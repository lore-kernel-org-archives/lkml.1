Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYB2Ujy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYB2Ujy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761480AbYB2Ujj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:39:39 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:57417 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761368AbYB2Ujj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:39:39 -0500
Message-ID: <47C86DCA.5080706@davidnewall.com>
Date: Sat, 01 Mar 2008 07:10:42 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Pavel Roskin <proski@gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only	symbols
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <1204304352.6767.21.camel@localhost> <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv> <20080229201711.GF3234@tuxdriver.com>
In-Reply-To: <20080229201711.GF3234@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> On Fri, Feb 29, 2008 at 02:39:38PM -0500, Pavel Roskin wrote:
>   
>> I doubt ndiswrapper will ever be ported to the
>> userspace.  It's much more likely that some other approach will be used.
>>     
>
> Maybe it should be -- that might solve a lot of problems

Maybe it's time to rename it from "ndiswrapper" to "NdisWrapper".

How stupid do you have to be to not see that it will be fixed in any way
necessary.
