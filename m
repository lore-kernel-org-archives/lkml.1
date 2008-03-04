Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbYCDMqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbYCDMqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbYCDMpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:45:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:37520 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751749AbYCDMpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:45:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FtCght7AFmDiqhJY+Hf1+d/ONnl54Trjtoxnz0S
	wTVl6GO6vU+FT0
Subject: Re: [PATCH] block: fix residual byte count handling
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <47CD4355.4050401@gmail.com>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	 <20080304085944.GG6704@kernel.dk>
	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>  <47CD4355.4050401@gmail.com>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 13:45:41 +0100
Message-Id: <1204634741.17258.3.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 21:40 +0900, Tejun Heo wrote:

> Aiee... device going down after timing out on READ_DISC_INFO.  That's
> gruesome.  Can you please try the other patches?

I tried your last yesterday, and k3b worked fine.

	-Mike

