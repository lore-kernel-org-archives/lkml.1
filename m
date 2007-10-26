Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXJZLHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXJZLHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXJZLHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:07:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50153
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbXJZLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:07:29 -0400
Date: Fri, 26 Oct 2007 04:07:30 -0700 (PDT)
Message-Id: <20071026.040730.17032573.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: bunk@kernel.org, sri@us.ibm.com, lksctp-developers@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 sctp_update_copy_cksum()
From: David Miller <davem@davemloft.net>
In-Reply-To: <471FAB6A.4050204@hp.com>
References: <20071024162407.GD30533@stusta.de>
	<471FAB6A.4050204@hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 24 Oct 2007 16:30:34 -0400

> Adrian Bunk wrote:
> > sctp_update_copy_cksum() is no longer used.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ACK.

Applied, thanks!
