Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYH2JqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYH2JqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYH2Jpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:45:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38059 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYH2Jpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:45:53 -0400
Date: Fri, 29 Aug 2008 11:45:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mano@roarinelk.homelinux.net, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: MTD kobject warnings due to block layer changes
Message-ID: <20080829094537.GR20055@kernel.dk>
References: <20080829065029.GK20055@kernel.dk> <20080829165542L.fujita.tomonori@lab.ntt.co.jp> <20080829080123.GO20055@kernel.dk> <20080829171936Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829171936Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29 2008, FUJITA Tomonori wrote:
> On Fri, 29 Aug 2008 10:01:24 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > What about eg ide-cd?
> 
> I'm always SCSI biased.

:-)

Thanks, applied!

-- 
Jens Axboe

