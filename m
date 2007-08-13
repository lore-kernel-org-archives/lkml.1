Return-Path: <linux-kernel-owner+w=401wt.eu-S943643AbXHMM41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943643AbXHMM41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942652AbXHMHq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:46:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8496 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942638AbXHMHq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:46:27 -0400
Date: Mon, 13 Aug 2007 09:46:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [95/2many] MAINTAINERS - BLOCK LAYER
Message-ID: <20070813074624.GF23758@kernel.dk>
References: <46bff917.EmblDII2NfX3zJ2k%joe@perches.com> <20070813072851.GD23758@kernel.dk> <1186990866.10249.42.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186990866.10249.42.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13 2007, Joe Perches wrote:
> On Mon, 2007-08-13 at 09:28 +0200, Jens Axboe wrote:
> > drivers/block/ is block device drivers, not the block layer. That mostly
> > resides in block/, with some parts in fs/ as well.
> 
> ok, Do you want to be cc'd on mods in fs/*
> 
> F:	block/
> F:	fs/*

Not really, I'm only interested in select files in under fs/ - as are
most, I suspect.

-- 
Jens Axboe

