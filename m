Return-Path: <linux-kernel-owner+w=401wt.eu-S937483AbZDIXwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937483AbZDIXwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761050AbZDIXw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:52:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760760AbZDIXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:52:26 -0400
Date: Thu, 9 Apr 2009 16:49:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <13476.1239320297@redhat.com>
Message-ID: <alpine.LFD.2.00.0904091645010.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091628580.4583@localhost.localdomain> <20090409232152.13220.28141.stgit@warthog.procyon.org.uk> <20090409232157.13220.63863.stgit@warthog.procyon.org.uk> <13476.1239320297@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > David, please _look_ at your patches before sending them out.
> 
> I did.  I emailed it to myself first, and then accidentally lost the
> --diff-opts=-M I'd added when I was trying to email publically.
> 
> I think I'd probably better off sticking this in a GIT tree and getting you to
> pull it.

Heh. Yes, then you can use the "git request-pull" script that does it all 
for you.

That said, even just doing a simple

	alias stgit='stgit --diff-opts=-M'

might just avoid this in the future..

		Linus


