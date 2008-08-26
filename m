Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbYHZTEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbYHZTEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbYHZTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:03:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760267AbYHZTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:03:46 -0400
Date: Tue, 26 Aug 2008 12:02:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits
In-Reply-To: <20080826185636.GP20055@kernel.dk>
Message-ID: <alpine.LFD.1.10.0808261201420.3363@nehalem.linux-foundation.org>
References: <20080826070640.GR20055@kernel.dk> <alpine.LFD.1.10.0808261009180.3363@nehalem.linux-foundation.org> <20080826185636.GP20055@kernel.dk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Jens Axboe wrote:
> 
> I'll move those 1-2 patches to the 2.6.28 branch and resubmit the rest
> for you.

You will *delete* the absolute crap locking patch, that has no way of 
being even 2.6.28 material.

And you need to be a whole lot more careful.

			Linus
