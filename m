Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbZANCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbZANCMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZANCML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:12:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZANCMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:12:10 -0500
Date: Tue, 13 Jan 2009 18:10:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mtk.manpages@gmail.com
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
In-Reply-To: <cfd18e0f0901131739v5119271flc28b5531604e682@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901131808070.6528@localhost.localdomain>
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>  <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>  <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>  <20090113224941.36F19FC3DD@magilla.sf.frob.com> 
 <alpine.LFD.2.00.0901131629220.6528@localhost.localdomain>  <cfd18e0f0901131653y76a827b5i906fadce63ada56b@mail.gmail.com>  <alpine.LFD.2.00.0901131655040.6528@localhost.localdomain> <cfd18e0f0901131739v5119271flc28b5531604e682@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Jan 2009, Michael Kerrisk wrote:
> 
> It isn't an extension.  It's an accident.

Bah. It doesn't matter. It's an ABI. Your arguments make no sense - simply 
because there are other differences that means that if you develop under 
one OS, you can't expect it to run on another.

Arguing that "accident" is somehow different than "extension" is a totally 
inane and _idiotic_ argument. Because it's just arguing about the words, 
not about the end result.

If you're doing a dissertation in English literature, arguing about the 
words you use is valid. But if you're talking about operating systems, 
it's just pointless masturbation.

		Linus
