Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZDNJIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZDNJIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZDNJI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:08:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbZDNJI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:08:27 -0400
Date: Tue, 14 Apr 2009 02:08:18 -0700 (PDT)
Message-Id: <20090414.020818.174886786.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: linux-next: origin tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090414144317.026498df.sfr@canb.auug.org.au>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 14 Apr 2009 14:43:17 +1000

> sparc: asm/atomic.h on 32bit should include asm/system.h for xchg
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Just in case it wasn't clear, I'm applying this :)
