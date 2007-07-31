Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbXGaPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbXGaPpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXGaPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:45:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417AbXGaPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:45:26 -0400
Date: Tue, 31 Jul 2007 08:44:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Huey <billh@gnuppy.monkey.org>
cc: George Sescher <gesacs@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <20070731100511.GI32582@gnuppy.monkey.org>
Message-ID: <alpine.LFD.0.999.0707310842520.4161@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu>
 <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
 <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
 <20070731100511.GI32582@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Bill Huey wrote:
> 
> Here's the problem, *a lot* of folks can do scheduler development in and
> outside community, so what's with exclusive-only attitude towards the
> scheduler ?

There is no exclusive-only attitude towards the scheduler.

If you send me small and obvious improvements, they'll get applied to the 
scheduler, exactly the same way they get applied to anything else.

And if you try to rewrite everything, and do it on your own, and then 
don't even send me a patch, it also won't get applied. 

Surprise?

			Linus
