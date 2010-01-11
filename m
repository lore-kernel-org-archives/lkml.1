Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265Ab0AKLQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0AKLQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 06:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217Ab0AKLQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 06:16:34 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:52336 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0AKLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:16:33 -0500
Date: Mon, 11 Jan 2010 11:16:32 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Joe Perches <joe@perches.com>
cc: David Miller <davem@davemloft.net>, Stephen@Rothwell.id.au,
       netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: linux-next: net tree build failure
In-Reply-To: <1263197772.1907.44.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.00.1001111116070.29332@eddie.linux-mips.org>
References: <20100111184205.8d53fe5b.Stephen@Rothwell.id.au>         <20100111.000205.164473435.davem@davemloft.net> <1263197772.1907.44.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010, Joe Perches wrote:

> Perhaps it'd be better to kill off the use of bitrev in
> lib/vsprintf as Maciej thinks it broken.
> 
> Maybe use something like this?

 Thanks for fixing it.

  Maciej
