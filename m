Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZIAM5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZIAM5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZIAM5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:57:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:56394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbZIAM47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:56:59 -0400
Message-ID: <4A9D1A18.5000201@kernel.org>
Date: Tue, 01 Sep 2009 21:56:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Meelis Roos <mroos@linux.ee>
Subject: Re: [GIT PULL] percpu fixes for 2.6.31-rc8
References: <4A9D18B7.3010405@kernel.org>
In-Reply-To: <4A9D18B7.3010405@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 01 Sep 2009 12:56:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Linus.
> 
> Please consider pulling from the following percpu fixes tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

Ummm... one question.  The above tree is on top of the previous
for-linus fixes tree.  It pulls in to the current #master alright but
it would still be a merge instead of a fast-forward.  Would it be
better to prep fixes tree on top of the current #master so that it
results in fast-forward?  If that's the case, please let me know or
just cherry pick the top commit.

Thanks.

-- 
tejun
