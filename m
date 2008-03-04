Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYCDMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYCDMoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbYCDMnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:43:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:44127 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755957AbYCDMno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:43:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+XSH01Kn+X3G3uHr1eSL1sn1sW2HY6oVyaJSCX4W
	7UU1ibi0VlMjmk
Subject: Re: [PATCH] block: fix residual byte count handling
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com,
       tomof@acm.org, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <20080304123939.GM6704@kernel.dk>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	 <20080304085944.GG6704@kernel.dk>
	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>
	 <20080304123939.GM6704@kernel.dk>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 13:43:39 +0100
Message-Id: <1204634619.17258.0.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 13:39 +0100, Jens Axboe wrote:
> On Tue, Mar 04 2008, Mike Galbraith wrote:
> > 
> > On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> > 
> > > Looks excellent to me, has a variant of this been tested as OK by the
> > > users reporting the regression?
> > 
> > K3b burning seems to be a nogo here.  This is git pulled this morning
> > though, so it's a somewhat different tree than previously tested fwtw.
> 
> can you please try git as of this morning without any patches applied,
> and then pull
> 
> git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> into that and see if that works?

I'll give it a shot in a bit.

	-Mike

