Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbXI3Atb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbXI3Atb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 20:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbXI3AtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 20:49:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbXI3AtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 20:49:23 -0400
Date: Sat, 29 Sep 2007 17:49:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates 
In-Reply-To: <200709300023.l8U0Nq9m012266@agora.fsl.cs.sunysb.edu>
Message-ID: <alpine.LFD.0.999.0709291748160.3579@woody.linux-foundation.org>
References: <200709300023.l8U0Nq9m012266@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Sep 2007, Erez Zadok wrote:
> 
> Would you prefer if CodingStyle was reorganized or even split into (1)
> general principles and (2) details?  Perhaps we need a CodingStylePrinciples
> and a CodingStyleDetails?

I'm certainly ok with the split into two files.

What I'm not ok with is really important stuff (indentation), and then 
mixing in silly rules ("parenthesis are bad in printk's"?)

		Linus
