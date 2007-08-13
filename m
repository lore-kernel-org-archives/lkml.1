Return-Path: <linux-kernel-owner+w=401wt.eu-S945712AbXHMMwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945712AbXHMMwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940197AbXHMHla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:41:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2658 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940547AbXHMHl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:41:28 -0400
Subject: Re: [PATCH] [95/2many] MAINTAINERS - BLOCK LAYER
From: Joe Perches <joe@perches.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070813072851.GD23758@kernel.dk>
References: <46bff917.EmblDII2NfX3zJ2k%joe@perches.com>
	 <20070813072851.GD23758@kernel.dk>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 00:41:06 -0700
Message-Id: <1186990866.10249.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 09:28 +0200, Jens Axboe wrote:
> drivers/block/ is block device drivers, not the block layer. That mostly
> resides in block/, with some parts in fs/ as well.

ok, Do you want to be cc'd on mods in fs/*

F:	block/
F:	fs/*

?

