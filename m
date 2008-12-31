Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbYLaRcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbYLaRcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYLaRbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:31:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbYLaRbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:31:52 -0500
Date: Wed, 31 Dec 2008 09:31:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches, part 1
In-Reply-To: <alpine.LFD.2.00.0812310905580.5086@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812310930360.5086@localhost.localdomain>
References: <20081231074356.GA28946@ZenIV.linux.org.uk> <alpine.LFD.2.00.0812310905580.5086@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Linus Torvalds wrote:
> 
> There's tons of unnecessary "[PATCH, v5]" things in those commit headers, 
> and that seems to mean that you intentionally pass the "--keep" flag to 
> git to keep the crap in subject lines, rather than let git clean it up for 
> you.
> 
> Git by default will try to clean things up, so you literally have done 
> extra work to make your commits look like shit!

The alternative, of course, is that you're using some _really_ old git 
version, or that you have your own scripts that create the commits by 
hand. If so, please just update.

		Linus
