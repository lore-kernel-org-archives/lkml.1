Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYLZCFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYLZCFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 21:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYLZCFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 21:05:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35046
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbYLZCFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 21:05:43 -0500
Date: Thu, 25 Dec 2008 18:05:46 -0800 (PST)
Message-Id: <20081225.180546.25884866.davem@davemloft.net>
To: julia@diku.dk
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 13/13] net/appletalk: Remove redundant test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812211641590.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211641590.9555@pc-004.diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 21 Dec 2008 16:42:18 +0100 (CET)

> atif is tested for being NULL twice, with the same effect in each case.  I
> have kept the second test, as it seems to fit well with the comment above it.

Applied.

But please always CC: netdev on all networking patches, so that your
patch gets properly tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

I only caught this one by accident while scanning linux-kernel
postings.  Depending upon that kind of luck is not a good idea :)
