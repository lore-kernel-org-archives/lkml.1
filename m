Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYLMBDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYLMBDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 20:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYLMBDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 20:03:41 -0500
Received: from mail.fieldses.org ([66.93.2.214]:43078 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYLMBDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 20:03:40 -0500
Date: Fri, 12 Dec 2008 20:03:28 -0500
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081213010328.GA23224@fieldses.org>
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk> <20081212194703.GA17573@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212194703.GA17573@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 02:47:03PM -0500, bfields wrote:
> On Fri, Dec 12, 2008 at 06:28:27PM +0000, David Howells wrote:
> > Add a guide to using GIT's simpler features.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Just a couple random thoughts:

(Also: this patch applies to either the git or linux trees, and you sent
it to both mailing lists.  Looks like you meant it for linux, but you
might want to clarify....)

--b.

> 
> 	- The advantage of adding this to the kernel tree is that you
> 	  can tailor it for a more specific audience (kernel developers
> 	  and testers).  A lot of this (e.g. the object-database
> 	  discussion) seems to be generic introduction-to-git stuff.
> 	  Is there some canonical external documentation you could refer
> 	  to for that stuff, that would allow you to get more quickly to
> 	  the more tailored information?  If not, is there something you
> 	  could improve to the point where you *would* be comfortable
> 	  referring to it?
> 	- How much overlap is there with
> 	  Documentation/development-process/7.AdvancedTopics?  Should
> 	  there be cross-references between the two?
> 
> There's an awful lot of introductions to git out there now (and I've got
> my own share of the blame).
