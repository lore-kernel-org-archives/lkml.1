Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYKLBMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYKLBMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYKLBME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:12:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbYKLBMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:12:01 -0500
Date: Tue, 11 Nov 2008 17:11:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
In-Reply-To: <4918BBD4.3060306@garzik.org>
Message-ID: <alpine.LFD.2.00.0811111709410.3468@nehalem.linux-foundation.org>
References: <4917C449.2080504@kernel.org> <4918BBD4.3060306@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Nov 2008, Jeff Garzik wrote:
> 
> Now that this is resolved, please allow me a bit of grumbling.  I always
> thought the original course -- 2.6.29 -- was best for these patches.

You can blame me on that one. I actually pushed for these, since I was 
interested in seeing what the impact of it all was. My bad.

			Linus
