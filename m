Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYEEFVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYEEFVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYEEFUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:20:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40457
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbYEEFUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:20:50 -0400
Date: Sun, 04 May 2008 22:20:50 -0700 (PDT)
Message-Id: <20080504.222050.195185590.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: joe@perches.com, akpm@linux-foundation.org, paulmck@us.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] __ratelimit rewrite
From: David Miller <davem@davemloft.net>
In-Reply-To: <a8e1da0805042218l6fbacfd9sa139b00c3077895b@mail.gmail.com>
References: <a8e1da0805041958k30c03e20r6dd88f4135d6e5fe@mail.gmail.com>
	<1209955974.13011.10.camel@localhost>
	<a8e1da0805042218l6fbacfd9sa139b00c3077895b@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Young" <hidave.darkstar@gmail.com>
Date: Mon, 5 May 2008 13:18:30 +0800

> After searching the code, I guess DCCP-Sync ratelimit can use this feature.
> David, am I right?

I'm not familiar with the DCCP-Sync code, sorry.
