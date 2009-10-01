Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZJASoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZJASoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbZJASoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:44:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbZJASoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:44:05 -0400
Date: Thu, 1 Oct 2009 11:44:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block updates for 2.6.32-rc
In-Reply-To: <20090930174109.GD14918@kernel.dk>
Message-ID: <alpine.LFD.2.01.0910011143100.6996@localhost.localdomain>
References: <20090930174109.GD14918@kernel.dk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, Jens Axboe wrote:
> 
> This looks huge, but it's mostly a cciss driver update and the addition
> of drbd. I would have submitted this before -rc1, but Plumbers got in
> the way.

I'm perfectly happy to pull drbd, but please do it for the next merge 
window. There's been enough discussion about it that I think we'll be 
better off giving it some time.

		Linus
