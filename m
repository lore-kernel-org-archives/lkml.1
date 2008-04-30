Return-Path: <linux-kernel-owner+w=401wt.eu-S934229AbYD3WVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229AbYD3WVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765577AbYD3WVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:21:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33278
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933804AbYD3WVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:21:13 -0400
Date: Wed, 30 Apr 2008 15:21:11 -0700 (PDT)
Message-Id: <20080430.152111.147585215.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] net: fix returning void-valued expression
 warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209594005.24729.127.camel@brick>
References: <1209593023.24729.117.camel@brick>
	<20080430.150832.107441339.davem@davemloft.net>
	<1209594005.24729.127.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 30 Apr 2008 15:20:05 -0700

> This is just a _trivial_ way to make the sparse output easier for people
> to use day-to-day for the kernel. There's lots more to do, but this set
> removes all remaining integer as NUll/ returning void-value/ single bit
> signed bitfield warnings.

Absolutely, I have no problem with that.

So I'll likely apply your patch, thanks.
