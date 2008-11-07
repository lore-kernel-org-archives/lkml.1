Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYKGNu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYKGNu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYKGNuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:50:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYKGNuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:50:50 -0500
Date: Fri, 7 Nov 2008 08:50:48 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Matt Fleming <mjf@gentoo.org>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu
Subject: Re: [PATCH] ftrace: Allow section alignment
In-Reply-To: <5ff4a1e50811070525t56834306va8a975617de589b6@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811070850330.27455@gandalf.stny.rr.com>
References: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com>  <1226063896.2697.28.camel@twins> <5ff4a1e50811070525t56834306va8a975617de589b6@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Nov 2008, Matt Fleming wrote:

> 2008/11/7 Peter Zijlstra <peterz@infradead.org>:
> > On Fri, 2008-11-07 at 13:12 +0000, Matt Fleming wrote:
> >> Provide a means of aligning the __mcount_loc section.
> >
> > Not that I object to the patch, but this changelog needs work.
> >
> > Its wrong, it doesn't provide means, it plain does.
> > It doesn't tell us why.
> >
> 
> Would you like me to resubmit the patch with a better changelog?

Yes, because I'm not convinced that the change is needed.

-- Steve

