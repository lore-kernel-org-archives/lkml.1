Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXKRWHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXKRWHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXKRWHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:07:35 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:45347 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXKRWHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:07:34 -0500
Date: Sun, 18 Nov 2007 23:07:19 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Chris Wedgwood <cw@f00f.org>, Trond Myklebust <trond.myklebust@fys.uio.no>,
       LKML <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com
Subject: Re: 2.6.24-rc2 XFS nfsd hang
In-Reply-To: <Pine.LNX.4.64.0711181031110.29571@p34.internal.lan>
Message-ID: <alpine.DEB.0.99999.0711182305510.7426@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de> <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
 <20071116003410.GA16797@puku.stupidest.org> <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org> <20071116110315.GA27969@puku.stupidest.org> <1195222772.7653.16.camel@heimdal.trondhjem.org> <20071116214327.GA9685@puku.stupidest.org>
 <alpine.DEB.0.99999.0711181541280.30603@sheep.housecafe.de> <Pine.LNX.4.64.0711181031110.29571@p34.internal.lan>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007, Justin Piszcz wrote:
>> I wonder why so few people are seeing this, I'd have assumed that
>> NFSv3 && XFS is not sooo exotic...
> Still on 2.6.23.x here (also use nfsv3 + xfs).

So, it's the "too few people are testing -rc kernels" issue again :(

Christian.
-- 
BOFH excuse #118:

the router thinks its a printer.
