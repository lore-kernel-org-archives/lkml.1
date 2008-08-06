Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYHFWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYHFWsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYHFWqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:46:09 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:60478 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYHFWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:46:07 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Date: Wed, 6 Aug 2008 22:04:14 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <g7d74u$81o$1@taverner.cs.berkeley.edu>
References: <1217883616.27684.19.camel@localhost.localdomain>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1218060254 8248 128.32.168.222 (6 Aug 2008 22:04:14 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Wed, 6 Aug 2008 22:04:14 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris  wrote:
>There is a consensus in the security industry that protecting against
>malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
>of so-called on-access scanning is usable and reasonable approach.

This is at odds with my experience.  Are you sure you've been talking to
the right people?  Is it possible you've only been talking to A/V vendors?
I find it entirely plausible that there is such a consensus among A/V
vendors, but I'm pretty skeptical that the rest of the security community
would make this kind of claim.  What I hear, instead, is quite a bit of
skepticism about the future of A/V.

Here's an experiment for you.  Walk up to a random security expert and
ask them what they think of blacklisting as a foundation for building
secure systems.  Ask them what they think of the future of A/V in security
and whether they think A/V will be of increasing or decreasing relevance
to security in the future.  The answers might be educational.  Actually,
I suspect it's even possible you might find that many knowledgeable A/V
insiders privately share some of these same concerns about the future
of A/V -- look at how pretty much every major A/V vendor out there is
looking to diversify, to expand into other areas of computer security
and compliance, and to move beyond signature-based file scanners.

If you picked a bunch of computer security experts who don't work for an
A/V vendor and asked them what they thought about all this, I suspect
they'd be more likely to line up behind the kinds of comments that Ted
Tso has been posting.  Personally, I think Ted's comments have been
highly constructive, thoughtful, and well worth re-reading.
