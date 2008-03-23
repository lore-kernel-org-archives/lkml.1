Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYCWBFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYCWBFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 21:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYCWBFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 21:05:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55798
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbYCWBFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 21:05:35 -0400
Date: Sat, 22 Mar 2008 18:05:52 -0700 (PDT)
Message-Id: <20080322.180552.238705480.davem@davemloft.net>
To: julia@diku.dk
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/7] net/9p/trans_fd.c: remove unused variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803151702380.24178@ask.diku.dk>
References: <Pine.LNX.4.64.0803151702380.24178@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 15 Mar 2008 17:02:58 +0100 (CET)

> The variable cb is initialized but never used otherwise.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.
