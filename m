Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXG1R0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXG1R0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXG1R0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:26:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbXG1R0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:26:01 -0400
Date: Sat, 28 Jul 2007 10:25:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Chang <thenewme91@gmail.com>
cc: Kasper Sandberg <lkml@metanurb.dk>, CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <b14e81f00707280618m73461fdfx989d87a3a0074192@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707281017230.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <b14e81f00707280618m73461fdfx989d87a3a0074192@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Michael Chang wrote:
> 
> I do recall there is one issue on which Con wouldn't budge -- anything
> that involved boosting certain kinds of processes in the kernel.

I did that myself, so that's a non-issue.

No. The complaints were about the CK scheduler not being as responsive 
under load as even the _old_ scheduler was. I don't know why people ignore 
this fact. It was a long thread back in March or April, and I'm pretty 
sure the CK mailing list was cc'd.

Sure, most people don't actually have load-averages above ten etc, but 
it's important to do those well _too_. 

			Linus
