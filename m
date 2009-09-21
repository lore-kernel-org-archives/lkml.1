Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZIURKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZIURKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZIURKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:10:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51327
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbZIURKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:10:03 -0400
Date: Mon, 21 Sep 2009 10:10:21 -0700 (PDT)
Message-Id: <20090921.101021.193734103.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, paulus@samba.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2] perf vs d-cache aliasses
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090921140848.444528343@chello.nl>
References: <20090921140848.444528343@chello.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 21 Sep 2009 16:08:48 +0200

> 
> based on your vmalloc code, an alternative implementation that lets x86 stay
> with regular allocations.
> 
> While I'm sad to have to propose having two implementations around, I see no
> other way to please both sides.

If you guys want to maintain two implementations of the same thing,
that's fine with me :)

