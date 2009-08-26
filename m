Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZHZTWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZHZTWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZHZTWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:22:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49400
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZHZTWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:22:35 -0400
Date: Wed, 26 Aug 2009 12:22:48 -0700 (PDT)
Message-Id: <20090826.122248.47485961.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: drzeus-list@drzeus.cx, avi@redhat.com, minchan.kim@gmail.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
       netdev@vger.kernel.org
Subject: Re: Page allocation failures in guest
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908262148.59664.rusty@rustcorp.com.au>
References: <200908261147.17838.rusty@rustcorp.com.au>
	<20090826065501.7ab677b9@mjolnir.ossman.eu>
	<200908262148.59664.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 26 Aug 2009 21:48:58 +0930

> Dave, can you push this to Linus ASAP?

Ok.

> Subject: virtio: net refill on out-of-memory
> 
> If we run out of memory, use keventd to fill the buffer.  There's a
> report of this happening: "Page allocation failures in guest",
> Message-ID: <20090713115158.0a4892b0@mjolnir.ossman.eu>
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Applied, thanks.
