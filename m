Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXCEIoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXCEIoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXCEIoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:44:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55011
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbXCEIoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:44:38 -0500
Date: Mon, 05 Mar 2007 00:44:36 -0800 (PST)
Message-Id: <20070305.004436.41635733.davem@davemloft.net>
To: lorenzo.milesi@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <29c147bd0703050032k71a06603p89d541071be5d656@mail.gmail.com>
References: <29c147bd0703050032k71a06603p89d541071be5d656@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lorenzo Milesi" <lorenzo.milesi@gmail.com>
Date: Mon, 5 Mar 2007 09:32:04 +0100

> I found this patch
> http://lkml.org/lkml/2006/11/29/335 and actually seems to fix the
> problem. I'm running the latest 2.6.20 with the following patch since
> 1 week and I'm not having panics anymore.

The fix for that bug was put into the kernel long before
2.6.20, so 2.6.20 all by itself should work just fine.
