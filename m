Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbXG0Hyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbXG0Hyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762719AbXG0HyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:54:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761192AbXG0HyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:54:19 -0400
Date: Fri, 27 Jul 2007 00:53:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Josh Triplett <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
Message-Id: <20070727005349.512c2f8d.akpm@linux-foundation.org>
In-Reply-To: <46A9A18D.2050401@s5r6.in-berlin.de>
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	<m3abtir95x.fsf@maximus.localdomain>
	<46A93F92.6050708@s5r6.in-berlin.de>
	<20070726175929.730fc0be.akpm@linux-foundation.org>
	<46A9A18D.2050401@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 09:41:01 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Andrew Morton wrote:
> > On Fri, 27 Jul 2007 02:42:58 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> Besides, how about reorienting the CodingStyle text to the essential?
> ...
> > If sparse has gone and added a warning for this then it is more than
> > nitpicking.  Reducing the amount of noise coming out of sparse is useful.
> 
> Sure, that'd be useful.  But then, SubmitChecklist already tells us to
> check with sparse before submission.

rofl.  First we have to talk everyone into checking their stuff with gcc.

