Return-Path: <linux-kernel-owner+w=401wt.eu-S1763177AbYBMTd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763177AbYBMTd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYBMTdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:33:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbYBMTdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:33:18 -0500
Date: Wed, 13 Feb 2008 11:32:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: joe@perches.com, gregkh@suse.de, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-Id: <20080213113241.4949e46a.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
References: <20080213070215.GA11969@kroah.com>
	<20080212.230423.172781444.davem@davemloft.net>
	<1202887323.3129.10.camel@localhost>
	<20080213165924.GB10129@suse.de>
	<1202923995.3129.26.camel@localhost>
	<alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:13:42 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 13 Feb 2008, Joe Perches wrote:
> > 
> > MAINTAINERS is the most frequently patched file
> 
> Almost all of them merge perfectly, with no problems what-so-ever. And the 
> merge conflicts, when they happen, are generally really trivial, and never 
> cause any subtle run-time bugs even if they were to happen.
> 
> So in that sense, I think both MAINTAINERS and the deprecation schedule 
> are totally uninteresting. Yes, they have merge conflicts. But those merge 
> conflicts are really really easy to handle.
> 

yup.  I'll often get conflicts and rejects in those files from the git
trees which I don't even bother fixing.
