Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbYJJSCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbYJJSCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762433AbYJJSCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:02:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762183AbYJJSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:02:23 -0400
Date: Fri, 10 Oct 2008 11:02:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: [GIT PULL] block changes for 2.6.28
In-Reply-To: <20081010080916.GV19428@kernel.dk>
Message-ID: <alpine.LFD.2.00.0810101100190.3503@nehalem.linux-foundation.org>
References: <20081010080916.GV19428@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Jens Axboe wrote:
> 
> Please pull from:
> 
>         git://git.kernel.dk/linux-2.6-block.git for-2.6.28

Pulled, but...

Please don't do changelog entries like this:

> Jens Axboe (27):
>       block: revert part of d7533ad0e132f92e75c1b2eb7c26387b25a583c1

ok, so it had an explanation, but still. That shortlog entry isn't exactly 
helpful, is it?

		Linus
