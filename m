Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbZIXVmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbZIXVmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZIXVmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:42:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:33884 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZIXVme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:42:34 -0400
Date: Thu, 24 Sep 2009 14:36:20 -0700
From: Greg KH <gregkh@suse.de>
To: Pascal Terjan <pterjan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: go7007 does not build in linus HEAD
Message-ID: <20090924213620.GA21514@suse.de>
References: <e8ca35370909240223w6574a06dr8b32def058640aa6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8ca35370909240223w6574a06dr8b32def058640aa6@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 11:23:17AM +0200, Pascal Terjan wrote:
>   CC [M]  drivers/staging/go7007/s2250-board.o
> drivers/staging/go7007/s2250-board.c:24:26: error: s2250-loader.h: No
> such file or directory

The V4L developers have now adopted this driver in the staging tree,
could you forward this info to them (address found in MAINTAINERS), so
that they know to fix this?

thanks,

greg k-h
