Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbXJANoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbXJANoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXJANoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:44:08 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58615 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbXJANoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:44:07 -0400
Date: Mon, 1 Oct 2007 09:44:05 -0400
To: Bill Davidsen <davidsen@tmr.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel   2.6.22.7
Message-ID: <20071001134405.GA16330@csclub.uwaterloo.ca>
References: <46F77A85.6020202@nerdgrounds.com> <20070924104940.50a52cf3.randy.dunlap@oracle.com> <46FD7104.9070609@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FD7104.9070609@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 05:24:20PM -0400, Bill Davidsen wrote:
> I'll offer this suggestion, knowing it may piss you off, given the 
> difficulty of preserving whitespace on *many* mailers without using 
> attachments, and given that attachments can be saved easily without 
> prying them out of the message, why don't you (one person) switch to a 
> capable mail agent, if only for patches, instead of trying to teach many 
> people to jump through hoops to avoid whitespace issues?
> 
> Not criticizing, just seems easier for everybody for you to avoid 
> teaching people things they don't find useful elsewhere, or getting 
> discouraged and not bothering.

Ehm, so you want people to save the patch, then when replying they
should load the patch into their (much better) mail client where they
can comment on the patch?  That is the reason the patch should be
inline.  People need to comment on it just as they would comment on any
other plain text email.

Well that and some people use git to import patches from the email in a
mostly automated way which also expects them to have the info at top
with signed-off and then the patch, which attachments also screw up.

So yes there are good reasons for getting a non broken mail client when
sending patches to lkml.

--
Len Sorensen
