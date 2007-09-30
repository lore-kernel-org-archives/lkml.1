Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbXI3D1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbXI3D1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXI3D1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:27:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54837 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXI3D1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:27:32 -0400
Date: Sun, 30 Sep 2007 04:27:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
Message-ID: <20070930032724.GY8181@ftp.linux.org.uk>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org> <18163.1191119041@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18163.1191119041@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 10:24:01PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 29 Sep 2007 11:18:05 PDT, Linus Torvalds said:
> 
> > "CodingStyle" should be about the big issues, not about details. Yes, 
> > we've messed that up over the years, but let's not continue that.
> > 
> > In other words, I'd suggest *removing* lines from CodingStyle, not adding 
> > them. The file has already gone from a "good general principles" to "lots 
> > of stupid details". Let's not make it worse.
> 
> I think there needs to be a "sense of fairness" attached here - CodingStyle
> should cover all the stuff maintainers/reviewers are allowed to whinge about.
> Otherwise, we get maintainers whinging about undocumented style rules, and
> we get code submitters who are unhappy because they have no real way to tell
> if their code really *is* stylistically lacking, or if they just have a
> jerk maintainer who wants to keep their code out-of-tree for political
> reasons.

... and no matter how many rules you put down, it's still possible to
write a code that will be awful stylistically while adhering to all of
them.  Religiously.

IOW, it's not going to eliminate that kind of fights.
