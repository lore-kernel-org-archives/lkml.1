Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbZJFS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbZJFS3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbZJFS3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:29:48 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:57975 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755972AbZJFS3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:29:47 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Date: Tue, 6 Oct 2009 20:29:08 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910061923.00723.elendil@planet.nl> <alpine.LFD.2.01.0910061030380.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910061030380.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062029.09910.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 18:29:10.0291 (UTC) FILETIME=[E58E4630:01CA46B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Linus Torvalds wrote:
> Have you missed the whole discussion about why it doesn't work?
> Have you missed the point on why it is FUNDAMENTALLY WRONG to do?

No, I've followed the discussion. I guess I just disagree with you as my 
perspective is different. I still think there are practical advantages to 
it, even if it is not 100% theoretically correct from a versioning PoV 
(which I've already said I agree with).

> You also seem to be making up more and more ludicrous examples of things
> to do.

Those ludicrous examples work very well for me and keep mixtures of stable, 
development and bisection kernels on 6 different architectures manageable. 
Call me weird.

I was not proposing my scheme as a general solution, but just presenting it 
as an example of what can be done locally.

Anyway, as long as I can continue to follow my own scheme, I'm happy 
enough.

> Why the f*ck cares about somebody taking a random git tree, tarring it
> up, and then building it like that? 

Because they are not random. I build inbetween trees mostly when I see that 
fixes for issues I've seen have been merged. My method, making use of the 
possibilities of the distro package management system, gives me perfect 
version management for these kernels. And that is something, I do care 
about (for my own systems, not as something to force on others).

Cheers,
FJP
