Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZFSGJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZFSGJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZFSGJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:09:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42177 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZFSGJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:09:24 -0400
Date: Fri, 19 Jun 2009 08:09:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: rename CONFIG_LBD to CONFIG_LBDAF
Message-ID: <20090619060926.GF11363@kernel.dk>
References: <200904251714.52020.bzolnier@gmail.com> <200906071539.10701.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906071539.10701.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07 2009, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 25 April 2009 17:14:50 Bartlomiej Zolnierkiewicz wrote:
> > Follow-up to "block: enable by default support for large devices
> > and files on 32-bit archs".
> > 
> > Rename CONFIG_LBD to CONFIG_LBDAF to:
> > - allow update of existing [def]configs for "default y" change
> > - reflect that it is used also for large files support nowadays
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> ping?

Applied

-- 
Jens Axboe

