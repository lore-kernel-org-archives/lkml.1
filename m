Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbZFXTVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbZFXTVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZFXTVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:21:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbZFXTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:21:40 -0400
Date: Wed, 24 Jun 2009 12:21:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <Pine.LNX.4.64.0906242210520.25779@melkki.cs.Helsinki.FI>
Message-ID: <alpine.LFD.2.01.0906241221040.3154@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org>  <20090624094622.d0b0fd82.akpm@linux-foundation.org>  <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>  <20090624105517.904f93da.akpm@linux-foundation.org>  <4A426825.80905@cs.helsinki.fi> 
 <20090624113037.7d72ed59.akpm@linux-foundation.org>  <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <84144f020906241144of2c85c7xc5f258a7837896c9@mail.gmail.com> <alpine.LFD.2.01.0906241147460.3240@localhost.localdomain>
 <Pine.LNX.4.64.0906242210520.25779@melkki.cs.Helsinki.FI>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Pekka J Enberg wrote:
> > 
> > Please integrate that, and take my patch too if you would (add my sign-off 
> > or just do your own version)? Or should I just apply them?
> 
> Whatever suits you best. I don't have my laptop with me at home so I can't 
> test them or send a pull request. I'm including a compile-tested patch 
> here in case you want to go ahead and merge them.

Ok, I committed both patches. Thanks,

		Linus
