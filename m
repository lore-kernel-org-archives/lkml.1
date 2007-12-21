Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbXLUWwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbXLUWwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXLUWwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:52:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbXLUWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:52:47 -0500
Date: Fri, 21 Dec 2007 14:51:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.9999.0712211449320.21557@woody.linux-foundation.org>
References: <1197049846.1645.68.camel@localhost.localdomain>  <20071211143336.GA17866@elte.hu>  <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>  <20071221120908.GA15926@elte.hu>
 <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com> <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Dec 2007, Christoph Lameter wrote:
>
> Actually thanks for pointing that out Pekka.... Here is a patch that takes 
> the regression almost completely away

Now *this* is what I wanted to see - rather than argue against other 
peoples performance regression reports, an actual patch that acknowledges 
the problem.

Thanks.

And now, can the people who made the problem reports and complained about 
SLUB please test the patch - the ball is now in your court!

		Linus
