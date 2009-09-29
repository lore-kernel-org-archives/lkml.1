Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZI2AQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZI2AQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZI2AQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:16:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41660
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbZI2AQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:16:06 -0400
Date: Mon, 28 Sep 2009 17:16:25 -0700 (PDT)
Message-Id: <20090928.171625.04541003.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@elte.hu, hpa@zytor.com
Subject: Re: [PATCH 2/3] sparc64: implement page mapping percpu first chunk
 allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AC15182.4020603@kernel.org>
References: <4ABB6C80.20109@kernel.org>
	<20090928.143656.208349447.davem@davemloft.net>
	<4AC15182.4020603@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 29 Sep 2009 09:14:58 +0900

> Ah... great but unless you object, I think it would be better to push
> it out anyway just to make things a bit more robust and ease tracking
> and debugging when something goes wrong.  The added code is small and
> ditched once boot is complete.  What do you think?

That's fine with me:

Acked-by: David S. Miller <davem@davemloft.net>
