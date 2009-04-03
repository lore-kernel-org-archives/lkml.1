Return-Path: <linux-kernel-owner+w=401wt.eu-S935973AbZDCTUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935973AbZDCTUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934553AbZDCTUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:20:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936021AbZDCTUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:20:33 -0400
Date: Fri, 3 Apr 2009 12:17:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Fasheh <mfasheh@suse.com>
cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] Ocfs2 updates for 2.6.30
In-Reply-To: <alpine.LFD.2.00.0904031208490.4015@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904031214260.4015@localhost.localdomain>
References: <20090403184605.GC14571@wotan.suse.de> <alpine.LFD.2.00.0904031208490.4015@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Linus Torvalds wrote:
>
> Are they likely? Probably not. But that's not the point. The point is that 
> you barely had time to compile that thing, much less give it any testing.

Gaah. I pulled it anyway. Today, I just can't find it in me to care about 
ocfs2 testing.

But please - keep this in mind. Even if the commit is old, when you rebase 
it, you really do move it into a whole new world order. And yes, it 
_usually_ works just fine. 

But to make sure, please do spend some time after setting up the tree to 
make sure that what I get really is something that you know is what I want 
to get.

		Linus
