Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbZFWVlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbZFWVlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZFWVkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:40:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZFWVkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:40:52 -0400
Date: Tue, 23 Jun 2009 14:40:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] NFS private namespace patchset
In-Reply-To: <20090623213309.GK8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0906231438390.3240@localhost.localdomain>
References: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org> <alpine.LFD.2.01.0906221238370.3240@localhost.localdomain> <20090623213309.GK8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Jun 2009, Al Viro wrote:
> On Mon, Jun 22, 2009 at 12:40:33PM -0700, Linus Torvalds wrote:
> > 
> > 
> > Al? Where are you?
> 
> Back, digging through the mailbox.

Ok, I applied Trond's private namespace patchset, since I was planning on 
doing -rc1 today (now reconsidering due to the bulk of stuff I've done 
today, it might be tomorrow).

But I'm still interested in fixes and particularly in the path ref leak 
issue.

Oh, and Trond just sent out a cleanup patch that looked fine too.

			Linus
