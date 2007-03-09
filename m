Return-Path: <linux-kernel-owner+w=401wt.eu-S2992984AbXCIFZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992984AbXCIFZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992983AbXCIFZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:25:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992982AbXCIFZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:25:24 -0500
Date: Thu, 08 Mar 2007 21:25:23 -0800 (PST)
Message-Id: <20070308.212523.45514581.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Fix sparc TIF_USEDFPU flag atomicity
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070309031227.GC9462@Krystal>
References: <20070309031227.GC9462@Krystal>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 8 Mar 2007 22:12:27 -0500

> Fix sparc TIF_USEDFPU flag atomicity
> 
> Non atomic update of TIF can be very dangerous, except at thread structure
> creation time. Here I standardize the TIF_USEDFPU usage of the sparc arch.
> 
> Applies on 2.6.20.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Also applied, thanks a lot.
