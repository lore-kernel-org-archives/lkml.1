Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0BSGxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:53:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38853
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397Ab0BSGxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:53:34 -0500
Date: Thu, 18 Feb 2010 22:53:49 -0800 (PST)
Message-Id: <20100218.225349.258488745.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristoffer@gaisler.com
Subject: Re: linux-next: build failure after final merge (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100219173713.e3f9f386.sfr@canb.auug.org.au>
References: <20100219173713.e3f9f386.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Feb 2010 17:37:13 +1100

> I assume that this driver was written and tested only on Sparc ... maybe
> it should depend on SPARC?
> 
> I have reverted that commit for today.

I'll take a look at what it really depends upon.

Thanks.
