Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbXI3AYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbXI3AYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 20:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXI3AYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 20:24:06 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:54980 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbXI3AYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 20:24:05 -0400
Date: Sat, 29 Sep 2007 20:23:52 -0400
Message-Id: <200709300023.l8U0Nq9m012266@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates 
In-reply-to: Your message of "Sat, 29 Sep 2007 11:18:05 PDT."
             <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>, Linus Torvalds writes:
> 
> 
> On Fri, 28 Sep 2007, Erez Zadok wrote:
> > 
> >  Documentation/CodingStyle         |   88 +++++++++++++++++++++++++++++++++++++-
> 
> I'm not very happy with this.
> 
> "CodingStyle" should be about the big issues, not about details. Yes, 
> we've messed that up over the years, but let's not continue that.
> 
> In other words, I'd suggest *removing* lines from CodingStyle, not adding 
> them. The file has already gone from a "good general principles" to "lots 
> of stupid details". Let's not make it worse.
> 
> 			Linus

There's a lot of good value in having all those details, as it helps people
standardize on more common practices, including details.  I think removing
all those details may only increase the amount-of less-accepted code to be
posted, resulting in more lkml people having to repeat themselves on what
not to do.  Only now, they won't be able to point people to the CodingStyle
file for what they should do right.

Would you prefer if CodingStyle was reorganized or even split into (1)
general principles and (2) details?  Perhaps we need a CodingStylePrinciples
and a CodingStyleDetails?

IOW, where should that very useful info live?

Erez.
