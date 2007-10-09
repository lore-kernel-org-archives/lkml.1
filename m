Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXJILXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXJILXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXJILXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:23:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21182 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXJILXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:23:33 -0400
Date: Tue, 9 Oct 2007 13:24:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 0/9] compat_ioctl: introduce block/compat_ioctl.c
Message-ID: <20071009112419.GK5241@kernel.dk>
References: <20071006181902.141862534@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006181902.141862534@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06 2007, Arnd Bergmann wrote:
> This is my block ioctl series split up into managable chunks. I'm not
> really sure about the last two of these, I'd prefer to get a second
> opinion on those.
> 
> Please apply once your tests have gone though.

Goodness, thanks a lot Arnd! Applied 1-7 (with v2 of patch #1).

-- 
Jens Axboe

