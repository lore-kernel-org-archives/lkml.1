Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXKNXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXKNXFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXKNXFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:05:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbXKNXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:05:21 -0500
Date: Wed, 14 Nov 2007 15:05:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heikki Orsila <shdl@zakalwe.fi>,
       Stephen Hemminger <shemminger@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <20071114222222.GJ8865@zakalwe.fi>
Message-ID: <alpine.LFD.0.9999.0711141459550.2786@woody.linux-foundation.org>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <200711140356.31483.nickpiggin@yahoo.com.au> <alpine.LFD.0.9999.0711141144080.2786@woody.linux-foundation.org>
 <20071114222222.GJ8865@zakalwe.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Heikki Orsila wrote:
> 
> See
> 	http://bugzilla.kernel.org/show_bug.cgi?id=9321
> 
> for more information.

That's a pretty unhelpful thing. It doesn't describe the breakage at all, 
so there is hardly much "more info". 

You've also apparently made all the attachements "octet-streams", so they 
are singularly painful to look at (ie no normal web-browser will show 
them, you have to save them to a file and look at them there). 

That said, I think I'll revert it, since it certainly fits the bill, but 
that's a really quite unreadable bug-report.

I finally found the actual description of the problem (by following 
multiple links), but really, if people want me to revert things, I would 
*strongly* suggest they make it *obvious* what's going on in the email to 
me that says "please revert".

Because quite frankly, if that email doesn't explain why something should 
be reverted (and just points to other things), it doesn't really cut it.

		Linus
