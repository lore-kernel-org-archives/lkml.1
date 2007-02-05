Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXBELv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXBELv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbXBELv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:51:57 -0500
Received: from brick.kernel.dk ([62.242.22.158]:8920 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbXBELv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:51:56 -0500
Date: Mon, 5 Feb 2007 12:54:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: elevator oops [Was: 2.6.20-rc6-mm1]
Message-ID: <20070205115421.GB4487@kernel.dk>
References: <20070127234928.64d8e437.akpm@osdl.org> <45BC82A5.1020403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BC82A5.1020403@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28 2007, Jiri Slaby wrote:
> Andrew Morton napsal(a):
> >Temporarily at
> >
> >	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
> 
> Under disk load I get disk:
> ------------[ cut here ]------------
> kernel BUG at /home/l/latest/xxx/block/cfq-iosched.c:1026!

I fixed this one today, it was a typo on my part. I'll push the cfq
updates to #for-akpm again for more testing.

-- 
Jens Axboe

