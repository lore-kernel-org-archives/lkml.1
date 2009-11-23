Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZKWEnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZKWEnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 23:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbZKWEnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 23:43:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47804
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756338AbZKWEne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 23:43:34 -0500
Date: Sun, 22 Nov 2009 20:43:52 -0800 (PST)
Message-Id: <20091122.204352.193610958.davem@davemloft.net>
To: jaswinder@kernel.org
Cc: randy.dunlap@oracle.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix missing kernel-doc notation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1258877946.4495.52.camel@ht.satnam>
References: <1258877946.4495.52.camel@ht.satnam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Sun, 22 Nov 2009 13:49:06 +0530

> 
> Fix the following htmldocs warning:
> 
>   Warning(net/core/dev.c:5378): bad line:
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Applied to net-next-2.6

Please make it explicit what tree the patch is against and intended
to be applied to.  I had to try net-2.6 and net-next-2.6 by hand to
figure out where this patch was targeted.

Thanks.
