Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYAXXlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYAXXlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYAXXlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:41:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbYAXXlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:41:16 -0500
Date: Thu, 24 Jan 2008 15:41:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24
In-Reply-To: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0801241529440.15329@hp.linux-foundation.org>
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jan 2008, Linus Torvalds wrote:
> 
> The release is out there (both git trees and as tarballs/patches), and for 
> the next week many kernel developers will be at (or flying into/out of) 
> LCA in Melbourne, so let's hope it's a good one.

Since I already had two kernel developers asking about the merge window 
and whether people (including me) traveling will impact it, the plan right 
now is to keep the impact pretty minimal. So yes, it will probably extend 
the window from the regular two weeks, but *hopefully* not by more than a 
few days.

I'm going to try to merge at least some stuff while I'm in Melbourne, and 
I'd expect that most of the stuff that happens during LCA is code that is 
already pending to be merged (that's how the merge window is _supposed_ to 
work, after all, but with the 2.6.24 release cycle being longer than usual 
I suspect it's actually true in practice too).

And the second week of the merge window I'll be back again.

If I have bad bandwidth or am just goofing off during LCA, or if I end up 
being too jetlagged to merge well after, that will obviously push out 
things. And the same thing obviously goes for any other maintainer in the 
same condition. 

I'd hope that the git users to be in fairly good condition (with hopefully 
much of the stuff pending for 2.6.25 ready to go), and would worry more 
about people like Andrew in particular. So let's see how this works out.

In short: I'm hoping that there won't be a big impact, but hey, let's be 
flexible. Who knows what happens..

			Linus
