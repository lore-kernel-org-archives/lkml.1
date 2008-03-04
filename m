Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbYCDTdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbYCDTdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762021AbYCDTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:33:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:43563 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755046AbYCDTdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:33:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/dXqpvdaLdgsIHtHQEIMwZT22b2WNJb9mYIMEk4e
	/MT+LHJeK6HVNi
Subject: Re: [PATCH] block: fix residual byte count handling
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>, FUJITA Tomonori <tomof@acm.org>,
       fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <20080304192551.GU6704@kernel.dk>
References: <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net> <47CD4355.4050401@gmail.com>
	 <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com>
	 <47CD7611.2030606@gmail.com> <47CD7C05.1080707@gmail.com>
	 <1204656328.6598.1.camel@homer.simson.net>
	 <20080304192551.GU6704@kernel.dk>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 20:33:16 +0100
Message-Id: <1204659196.6284.7.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 20:25 +0100, Jens Axboe wrote:
> On Tue, Mar 04 2008, Mike Galbraith wrote:
> > 
> > On Wed, 2008-03-05 at 01:42 +0900, Tejun Heo wrote:
> > 
> > > The following patch gets the writing going.
> > 
> > Bingo.
> 
> Pretty please test this on top of current -git?

?  That's the patch I just tested, and the tree.  Oh.. 976dde0..87baa2b
just a sec....

	-Mike

