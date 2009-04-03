Return-Path: <linux-kernel-owner+w=401wt.eu-S935894AbZDCTQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935894AbZDCTQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZDCTQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:16:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbZDCTQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:16:08 -0400
Date: Fri, 3 Apr 2009 12:13:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Fasheh <mfasheh@suse.com>
cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] Ocfs2 updates for 2.6.30
In-Reply-To: <20090403184605.GC14571@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0904031208490.4015@localhost.localdomain>
References: <20090403184605.GC14571@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Mark Fasheh wrote:
> 
> 	Here is the Ocfs2 changes for this merge window. I sent all these
> patches out to the list a couple weeks ago. Original mail is attached.

Hmm. And I can _guarantee_ that none of these patches were actually tested 
as-is, because they were all rebased just minutes before the send.

 - top commit:

	Commit:     Mark Fasheh <mfasheh@suse.com>
	CommitDate: Fri Apr 3 11:39:26 2009 -0700

 - email:

	Date: Fri, 3 Apr 2009 11:46:05 -0700
	From: Mark Fasheh <mfasheh@suse.com>

So any possible subtle interactions with any other changes would never 
have been tested very much before the "please pull".

Are they likely? Probably not. But that's not the point. The point is that 
you barely had time to compile that thing, much less give it any testing.

The whole "it compiles, it's perfect, ship it" mentality is _strictly_ 
only for me.

Quod licet Jovi, non licet bovi.

		Linus
