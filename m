Return-Path: <linux-kernel-owner+w=401wt.eu-S1763429AbYALBtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763429AbYALBtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbYALBs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:48:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35795
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbYALBs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:48:58 -0500
Date: Fri, 11 Jan 2008 17:48:57 -0800 (PST)
Message-Id: <20080111.174857.258424243.davem@davemloft.net>
To: yoshfuji@linux-ipv6.org
Cc: andi@firstfloor.org, vaf@cisco.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] ipv4: enable use of 240/4 address space
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080111.214120.129309556.yoshfuji@linux-ipv6.org>
References: <20080108011057.GA21168@cisco.com>
	<p73bq7smx1t.fsf@bingen.suse.de>
	<20080111.214120.129309556.yoshfuji@linux-ipv6.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Date: Fri, 11 Jan 2008 21:41:20 +0900 (JST)

> There is no positive consesus on this draft
> at the intarea meeting in Vancouver, right?
> 
> We cannot / should not enable that space until we have reached
> a consensus on it.

This is so incredibly incorrect.

There is consensus on making network stacks able to use this
address space.  And that is all that the patch does.

The consensus is only missing on whether to make the address
space public or private.

This is also clearly spelled out in the draft.

It is important to get as large of a head start on this as
possible because of how long it takes to deploy something
like this.
