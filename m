Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXI3DgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXI3DgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXI3DgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:36:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbXI3DgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:36:02 -0400
Date: Sat, 29 Sep 2007 20:35:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
In-Reply-To: <13255.1191122973@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.0.999.0709292034460.3579@woody.linux-foundation.org>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
 <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
 <18163.1191119041@turing-police.cc.vt.edu>           
 <alpine.LFD.0.999.0709291959400.3579@woody.linux-foundation.org>
 <13255.1191122973@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Sep 2007, Valdis.Kletnieks@vt.edu wrote:
> 
> I kind of meant the *maintainers* couldn't whine about things not in 
> CodingStyle ;)

No, I understood you.

I'm personally of the opinion that the automated style checking, and 
having detailed rules is always a mistake. 

It's *much* better to teach people the big things. And the small things 
will vary from person to person _anyway_, so it's not like you can really 
document them.

		Linus
