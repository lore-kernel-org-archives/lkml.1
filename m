Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbXJZLV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbXJZLV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXJZLVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:21:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33248
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbXJZLVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:21:48 -0400
Date: Fri, 26 Oct 2007 04:21:49 -0700 (PDT)
Message-Id: <20071026.042149.216714577.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: bunk@kernel.org, sri@us.ibm.com, lksctp-developers@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] net/sctp/auth.c: make 3 functions static
From: David Miller <davem@davemloft.net>
In-Reply-To: <471FAABA.4080006@hp.com>
References: <20071024162428.GJ30533@stusta.de>
	<471FAABA.4080006@hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 24 Oct 2007 16:27:38 -0400

> Adrian Bunk wrote:
> > This patch makes three needlessly global functions static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ACK.  Thanks for catching these..

Applied, thanks everyone.
