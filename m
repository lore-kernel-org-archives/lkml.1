Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYH1M3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYH1M3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYH1M3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:29:42 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:34766 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750709AbYH1M3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:29:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bhX3VB94nSbPcPoS5bZXCjJsQ1Gy3rDtQ82Ws9aiSS3/m1WS/cbSy/wubJ7J+MQwvFNhZJG4r2yVqObREDz7wF5kUv8l1SleV7PcQw1kUY++IHv9McAVijIA2OPe2yH/6jNjuPDTuHDTZoEejyMmOCuDKSGsWQpLiDn9hgxNCIg=  ;
X-YMail-OSG: zrHqlYYVM1mCgSeeMZgeQkNqQYT5r7PUxA.FigfwssQDGBsJP8BY2JiZ_I3aR5BodpzAEJnw.CZzd8rYCBlUOuqF.pICRIV69uQUwlGcNcBOg9FnwN8iQRXz3blhtG8qgKY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Thu, 28 Aug 2008 22:29:34 +1000
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu>
In-Reply-To: <20080828105408.GA4488@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808282229.34414.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 20:54, Ingo Molnar wrote:

> This fundamental lack of experience weakens all your arguments and i
> dont even know why you are arguing about it.

BTW. this is funny that you just decide you can somehow "weaken"
my technical arguments because of some of my personal attribute
you believe about me.

You don't know why I am arguing? I'll put it very simply one more
time.

- This behaviour has changed the kernel's userspace API in a way
  that can break existing applications.

That is my primary point. If you think it gets somehow weaker
because you don't think I have ever locked up my workstation with
an RT task, then I give up arguing with you.
