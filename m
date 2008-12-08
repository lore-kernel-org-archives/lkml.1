Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbYLHJLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbYLHJLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYLHJKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:10:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45194
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbYLHJKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:10:43 -0500
Date: Mon, 08 Dec 2008 01:10:43 -0800 (PST)
Message-Id: <20081208.011043.229232186.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparc: replace for_each_cpu_mask_nr with for_each_cpu
From: David Miller <davem@davemloft.net>
In-Reply-To: <200812072136.17757.rusty@rustcorp.com.au>
References: <200812072136.17757.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:36:17 +1030

> Simple replacement, now the _nr is redundant.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>

I had to shoe-horn this into sparc-next-2.6 since we've
fully unified both sparc ports to be under arch/sparc.

Applied, thanks!
