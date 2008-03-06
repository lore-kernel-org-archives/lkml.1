Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbYCFL1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbYCFL1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758797AbYCFL1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:27:18 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59980 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYCFL1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:27:17 -0500
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
	the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200803062156.58230.nickpiggin@yahoo.com.au>
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
	 <200803062057.50181.nickpiggin@yahoo.com.au>
	 <1204798585.4325.8.camel@frecb07144>
	 <200803062156.58230.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Thu, 06 Mar 2008 12:29:38 +0100
Message-Id: <1204802978.4325.11.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le jeudi 06 mars 2008 à 21:56 +1100, Nick Piggin a écrit :
> On Thursday 06 March 2008 21:16, Laurent Vivier wrote:
> > Le jeudi 06 mars 2008 à 20:57 +1100, Nick Piggin a écrit :
> 
> > > Do you think we do something similar for drivers/block/brd.c too? I'd
> > > like to try to maintain parity between them where possible...
> >
> > I think it is possible  (I've the same patch for NBD too), but I think
> > it is completely useless.
> 
> It's useful for testing, and for minimising the divergence in the
> code.

OK, I can try to submit a patch, if you want...

Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
"Programmers who subconsciously view themselves as artists
 will enjoy what they do and will do it better." D. Knuth

