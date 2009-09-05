Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZIEVoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZIEVoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZIEVox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:44:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:44924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZIEVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:44:53 -0400
Message-ID: <4AA2DBD0.1000106@kernel.org>
Date: Sun, 06 Sep 2009 06:44:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Meelis Roos <mroos@linux.ee>
Subject: Re: [GIT PULL] percpu fixes for 2.6.31-rc8
References: <4A9D18B7.3010405@kernel.org> <4A9D1A18.5000201@kernel.org> <alpine.LFD.2.01.0909051422130.3414@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909051422130.3414@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 05 Sep 2009 21:44:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Linus Torvalds wrote:
> On Tue, 1 Sep 2009, Tejun Heo wrote:
>> Ummm... one question.  The above tree is on top of the previous
>> for-linus fixes tree.  It pulls in to the current #master alright but
>> it would still be a merge instead of a fast-forward.  Would it be
>> better to prep fixes tree on top of the current #master so that it
>> results in fast-forward?  If that's the case, please let me know or
>> just cherry pick the top commit.
> 
> No, I actually prefer people to avoid rebasing unless they have some real 
> reason for it. My pulls almost always end up being merges anyway, since I 
> pull from several people, so even if you were to have rebased, it would 
> _not_ have been a fast-forward for me, since I'd in the meantime have 
> pulled from others anyway.

Alright, thanks for the explanation.  Will do as advised.

-- 
tejun
