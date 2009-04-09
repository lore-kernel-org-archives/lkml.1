Return-Path: <linux-kernel-owner+w=401wt.eu-S1762199AbZDIXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbZDIXeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZDIXdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:33:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbZDIXdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:33:54 -0400
Date: Thu, 9 Apr 2009 16:31:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <20090409232157.13220.63863.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.0904091628580.4583@localhost.localdomain>
References: <20090409232152.13220.28141.stgit@warthog.procyon.org.uk> <20090409232157.13220.63863.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, David Howells wrote:
>
> Move arch headers from include/asm-frv/ to arch/frv/include/asm/.

David, please _look_ at your patches before sending them out.

Sure, you got the diffstat/summary right, but look at the patch itself - 
it doesn't actually match what you claimed to send out, and has it all as 
file creates/deletes, and so your email is - once more - over half a meg 
in size.

Yes, yes, I can apply it, and it will all end up being the same thing, but 
what I'm looking for is the knowledge that you can send out proper 
patches, so that future file moves don't have this. So I don't want to 
apply it before I know that the process works. Right now it doesn't.

		Linus
