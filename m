Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXLJORf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXLJORf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLJOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:17:27 -0500
Received: from phunq.net ([64.81.85.152]:42432 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752051AbXLJOR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:17:27 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Mon, 10 Dec 2007 06:17:24 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712100543.45204.phillips@phunq.net> <20071210135352.GL5008@kernel.dk>
In-Reply-To: <20071210135352.GL5008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712100617.24157.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 05:53, Jens Axboe wrote:
> > Got a plan?  Or does endless, pointless flaming feel more like
> > progress to you?
>
> Please, I'm not flaming you. I reviewed your code and pointed out
> errors, which was followed by lots of hand waving on your side
> instead of just sitting down and reading/fixing the bug.

Well that is indeed more civil language, if somewhat revisionist, since 
I distinctly remember being flamed by you from the word go.  Once 
again, thankyou for the catch.  A fairly trivial oversight that would 
have been caught sooner of later.  As for the typedef thing, that was 
just a spelling flame, admit it.

Truly, the way you were yelling I thought you had picked up a 
fundamental flaw instead of a simple misplaced line of code.

Now about that block writeout deadlock... it doesn't just affect my 
code, it basically breaks Linux as a storage platform, among other 
things.

Regards,

Daniel
