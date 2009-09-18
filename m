Return-Path: <linux-kernel-owner+w=401wt.eu-S1751198AbZIREhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbZIREhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 00:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZIREhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 00:37:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbZIREhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 00:37:07 -0400
Date: Thu, 17 Sep 2009 21:36:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: liqin.chen@sunplusct.com
cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, liqin.gnu@gmail.com
Subject: Re: [GIT PULL, v4] S+core architecture (arch/score) support
In-Reply-To: <OF121E6C6B.7861ECC9-ON48257635.0016A420-48257635.0017AD5F@sunplusct.com>
Message-ID: <alpine.LFD.2.01.0909172129230.4950@localhost.localdomain>
References: <OF121E6C6B.7861ECC9-ON48257635.0016A420-48257635.0017AD5F@sunplusct.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, liqin.chen@sunplusct.com wrote:
> 
> Would you please give me some advice,  or tell me where
> to get these informations, that will be helpful for us to co-work
> with you in the future.

See all the other pull requests out there. Some of them are scripted (by 
fairly trivial scripts), some of them are done by hand, but they tend to 
all have the same structure: a 'shortlog' of the commits that are new, and 
a diffstat (with summary) of the changes.

The important thing is that then I know what to expect from the pull, 
rather than having to pull blindly and see the end result (without really 
knowing whether that was what you intended for me to get).

There's even a 'git request-pull' script that comes with git that 
generates these things, although I'm not sure how many people use that 
particular script.

But just look for "please pull" on lkml, and you'll find a lot of 
examples.

Btw, I appreciate people not sending just the raw unedited "git 
request-pull" output. I'd like people to actually look at it to make sure 
that the thing matches what you expected, but also add a few lines of your 
own to describe the changes in your own words.

			Linus
