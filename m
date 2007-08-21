Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbXHUGDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbXHUGDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbXHUGDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:03:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbXHUGDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:03:43 -0400
Date: Mon, 20 Aug 2007 23:03:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com> <200708202102.58508.david-b@pacbell.net>
 <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
 <200708202148.45575.david-b@pacbell.net>
 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, Linus Torvalds wrote:
> 
> Ok. But in the meantime, I really think we should just revert the code 
> that causes a known regression.

Side note: one reason I'm interested in this is that my mac mini (now used 
by the kids) has had a very flaky USB mouse lately. Is it related? I have 
no idea, and probably not, but as a result I'm very interested in any USB 
regressions. There's *something* rotten with that mouse, and while it 
could be the mouse itself going bad, I think it started happening only 
after updating that machine to 2.6.23-rc1.

			Linus
