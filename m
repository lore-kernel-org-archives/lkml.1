Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbXHQB7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbXHQB7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 21:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXHQB7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 21:59:11 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1251 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752592AbXHQB7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 21:59:10 -0400
Date: Thu, 16 Aug 2007 21:58:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Rene Herman <rene.herman@gmail.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kyle Moffett <mrmacman_g4@mac.com>, Salikh Zakirov <salikh@gmail.com>,
       Junio C Hamano <gitster@pobox.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, <git@vger.kernel.org>
Subject: Re: [linux-pm] Re: Storing Maintainers info around the kernel tree
In-Reply-To: <46C4FD57.3000101@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0708162156550.9927-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Rene Herman wrote:

> On 08/16/2007 11:39 PM, Stefan Richter wrote:
> > Rene Herman wrote:
> 
> >> I personally don't think there's a whole lot wrong with more and more
> >> expecting people who submit patches (for whom this automation is
> >> intended) to be using git.
> > 
> > You mean "people who frequently submit patches for various different
> > subsystems".
> 
> Erm, I guess. Is that agreeing or disagreeing with me?

Don't forget also that the MAINTAINERS information is (or should be!)
used by people who want to submit bug reports, not just by people who
submit patches.  Bug reporters shouldn't need to use Git.

Alan Stern

