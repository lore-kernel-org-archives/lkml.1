Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbYGOQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbYGOQIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbYGOQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:08:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758326AbYGOQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:08:05 -0400
Date: Tue, 15 Jul 2008 09:07:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.10.0807150904290.3017@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487C242B.19490.17F690F7@pageexec.freemail.hu>, <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org> <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
> 
> by 'cover up' i meant that even when you know better, you quite
> consciously do *not* report the security impact of said bugs

Yes. Because the only place I consider appropriate is the kernel 
changelogs, and since those get published with the sources, there is no 
way I can convince myself that it's a good idea to say "Hey script 
kiddies, try this" unless it's already very public indeed.

> see my comment about reality above. heck, even linux vendors do track
> and announce them, it's part of the support they provide to paying
> customers (and even non-paying users).

Umm. And they mostly do a crap job at it, only focusing on a small 
percentage (the ones that were considered to be "big issues"), and because 
they do the reporting they also feel they have to have embargoes in place.

That's why I don't do reporting - it almost inevitably leads to embargoes.

So as far as I'm concerned, "disclosing" is the fixing of the bug. It's 
the "look at the source" approach.

		Linus
