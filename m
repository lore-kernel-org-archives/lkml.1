Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbXFGI2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbXFGI2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbXFGI2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:28:04 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:47152 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXFGI2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:28:03 -0400
Subject: Re: [PATCH -mm] Add LZO1X compression support to the kernel
From: Richard Purdie <rpurdie@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4cefeab80706062141u5fea846ane51c90dc89732db5@mail.gmail.com>
References: <1181150792.5686.51.camel@localhost.localdomain>
	 <4cefeab80706062141u5fea846ane51c90dc89732db5@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 09:27:36 +0100
Message-Id: <1181204856.6086.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 10:11 +0530, Nitin Gupta wrote:
> Your code now looks nice and clean. But I don't know what you want. I
> already spent lot of time on version 7 I posted and contains all those
> corrections which were suggested for my earlier version. I cannot ask
> you to look into possible problems (if any) in my code now since  you
> are not interested in that anyway. So, please continue this
> duplication.

What I (and others) repeatedly asked for was an explanation of why there
were the differences between the bytecode from your version and the
bytecode from mine. This was never explained by you and I was left to do
this myself. Sadly, doing so meant some duplication.

Anyhow, I think I can now explain the differences. Now we have two
versions, its a question of how to proceed. Basically one needs to be
merged into the other. I will try and compare the two patches and see
what differences we have.

Regards,

Richard


