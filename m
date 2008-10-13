Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYJMABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYJMABR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 20:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYJMABJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 20:01:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbYJMABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 20:01:08 -0400
Date: Sun, 12 Oct 2008 17:00:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] MN10300: MEI are renaming themselves to Panasonic
In-Reply-To: <21119.1223854070@redhat.com>
Message-ID: <alpine.LFD.2.00.0810121659530.3288@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org> <20081010235755.12643.43818.stgit@warthog.procyon.org.uk> <21119.1223854070@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, David Howells wrote:
> 
> Good point.  Do you want me to redo my patch on top of Randy's?

Yes please. I've pushed out the tree with Randy's changes, but you can 
obviously also just apply them and do the diff on top of that.

	Thanks
		Linus
