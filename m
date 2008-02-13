Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbYBMSOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbYBMSOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYBMSOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:14:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbYBMSOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:14:24 -0500
Date: Wed, 13 Feb 2008 10:13:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
cc: Greg KH <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
In-Reply-To: <1202923995.3129.26.camel@localhost>
Message-ID: <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
References: <20080213070215.GA11969@kroah.com>  <20080212.230423.172781444.davem@davemloft.net>  <1202887323.3129.10.camel@localhost>  <20080213165924.GB10129@suse.de> <1202923995.3129.26.camel@localhost>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Feb 2008, Joe Perches wrote:
> 
> MAINTAINERS is the most frequently patched file

Almost all of them merge perfectly, with no problems what-so-ever. And the 
merge conflicts, when they happen, are generally really trivial, and never 
cause any subtle run-time bugs even if they were to happen.

So in that sense, I think both MAINTAINERS and the deprecation schedule 
are totally uninteresting. Yes, they have merge conflicts. But those merge 
conflicts are really really easy to handle.

		Linus
