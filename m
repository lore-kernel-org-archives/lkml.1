Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXI2SSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXI2SSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbXI2SSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:18:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817AbXI2SSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:18:24 -0400
Date: Sat, 29 Sep 2007 11:18:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
In-Reply-To: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
Message-ID: <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Sep 2007, Erez Zadok wrote:
> 
>  Documentation/CodingStyle         |   88 +++++++++++++++++++++++++++++++++++++-

I'm not very happy with this.

"CodingStyle" should be about the big issues, not about details. Yes, 
we've messed that up over the years, but let's not continue that.

In other words, I'd suggest *removing* lines from CodingStyle, not adding 
them. The file has already gone from a "good general principles" to "lots 
of stupid details". Let's not make it worse.

			Linus
