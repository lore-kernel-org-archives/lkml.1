Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbYCDSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbYCDSqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765023AbYCDSpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:45:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:43257 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932606AbYCDSpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:45:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18zywgOGwAzAyVeuUqgiywEVlP2VgPNbX37cnWsLi
	9ZPY1KMvPRW0kV
Subject: Re: [PATCH] block: fix residual byte count handling
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <htejun@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com,
       fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <47CD7C05.1080707@gmail.com>
References: <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>	<47CD4355.4050401@gmail.com>
	 <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com>
	 <47CD7611.2030606@gmail.com>  <47CD7C05.1080707@gmail.com>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 19:45:28 +0100
Message-Id: <1204656328.6598.1.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-05 at 01:42 +0900, Tejun Heo wrote:

> The following patch gets the writing going.

Bingo.

	-Mike

