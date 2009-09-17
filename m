Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbZIQQcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbZIQQcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZIQQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:32:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758260AbZIQQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:32:13 -0400
Date: Thu, 17 Sep 2009 09:31:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: liqin.chen@sunplusct.com
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, liqin.gnu@gmail.com
Subject: Re: [GIT PULL, v4] S+core architecture (arch/score) support
In-Reply-To: <OF86273AF3.3B227B93-ON48257631.0006A5D3-48257631.0008C45B@sunplusct.com>
Message-ID: <alpine.LFD.2.01.0909170930050.4950@localhost.localdomain>
References: <OF86273AF3.3B227B93-ON48257631.0006A5D3-48257631.0008C45B@sunplusct.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Sep 2009, liqin.chen@sunplusct.com wrote:
> 
> We had setup a git server at gitserver.sunplusct.com,
> This repository contains Linux support for S+core CPU.
> it's base on Linux 2.6.31-rc7 and Arnd asm-generic repository.
> 
> please pull:
>         git pull git://gitserver.sunplusct.com/linux-2.6-score.git 
> for-linus
> 
> Changes in v4:
> Sending pull request again.
> 
> Changes in v3:
> With the help of Arnd and Roland.
> 
> Changes in v2:
> Christoph Hellwig and Arnd review it.

I want to see a proper pull request with diffstats etc (and the branch 
name on the same line etc). I realize I can just pull and look at what I 
get, but that's not how I work. I want to know that what I get is also 
what you expected to send to me, and perhaps equally importantly, I want 
to know that you know how to work with me in the future.

		Linus
