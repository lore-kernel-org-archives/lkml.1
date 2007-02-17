Return-Path: <linux-kernel-owner+w=401wt.eu-S1946351AbXBQBMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946351AbXBQBMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946356AbXBQBMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:12:30 -0500
Received: from brick.kernel.dk ([62.242.22.158]:3141 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946351AbXBQBM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:12:29 -0500
Date: Sat, 17 Feb 2007 02:12:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, i@stingr.net
Subject: Re: Add .splice_read to sockets?
Message-ID: <20070217011220.GA27345@kernel.dk>
References: <20070216230854.GX32467@stingr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216230854.GX32467@stingr.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17 2007, Paul P Komkoff Jr wrote:
> Hi!
> 
> Is there any plans to make splice(socket, ..., pipe, ...) work?

It's a work in-progress, latest effort is to import and attempt to fix
the stuff that Intel initially posted some months ago. See the
splice-net branch of the block git repo.

-- 
Jens Axboe

