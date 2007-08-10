Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbXHJRZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbXHJRZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbXHJRZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:25:41 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3207 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbXHJRZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:25:40 -0400
Date: Fri, 10 Aug 2007 19:25:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Michael Chang <thenewme91@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708101919270.1817@scrub.home>
References: <Pine.LNX.4.64.0708010439050.1817@scrub.home>  <20070801150742.GA23670@elte.hu>
 <p73ps27npu0.fsf@bingen.suse.de>  <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
  <20070801175004.GA17936@elte.hu>  <Pine.LNX.4.64.0708011955430.1817@scrub.home>
  <20070801190556.GA1199@elte.hu>  <Pine.LNX.4.64.0708100037460.1817@scrub.home>
  <20070810054948.GA5908@elte.hu>  <Pine.LNX.4.64.0708101459530.1817@scrub.home>
 <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 10 Aug 2007, Michael Chang wrote:

> On 8/10/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> > Is there any reason to believe my analysis is wrong?
> 
> Not yet, but if you give Ingo what he wants (as opposed to what you're
> giving him) it'll be easier for him to answer what's going wrong, and
> perhaps "fix" the problem to boot.
> 
> (The scripts gives info about CPU characteristics, interrupts,
> modules, etc. -- you know, all those "unknown" variables.)

He already has most of this information and the trace shows _exactly_ 
what's going on. All this information should be more than enough to allow 
an initial judgement whether my analysis is correct.
Also none of this information is needed to explain the CFS logic a little 
more, which I'm still waiting for...

bye, Roman
