Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751Ab0AKIoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0AKIoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593Ab0AKIo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:44:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47510
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab0AKIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:44:28 -0500
Date: Mon, 11 Jan 2010 00:44:36 -0800 (PST)
Message-Id: <20100111.004436.217049216.davem@davemloft.net>
To: joe@perches.com
Cc: Stephen@Rothwell.id.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, macro@linux-mips.org,
       hartleys@visionengravers.com
Subject: Re: linux-next: net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1263197772.1907.44.camel@Joe-Laptop.home>
References: <20100111184205.8d53fe5b.Stephen@Rothwell.id.au>
	<20100111.000205.164473435.davem@davemloft.net>
	<1263197772.1907.44.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 11 Jan 2010 00:16:12 -0800

> Perhaps it'd be better to kill off the use of bitrev in
> lib/vsprintf as Maciej thinks it broken.
> 
> Maybe use something like this?
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Yeah that sounds like a better idea, I think I'll commit
this instead.

Thanks Joe!
