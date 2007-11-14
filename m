Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbXKNXK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbXKNXK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbXKNXKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:10:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43974
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbXKNXKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:10:14 -0500
Date: Wed, 14 Nov 2007 15:10:13 -0800 (PST)
Message-Id: <20071114.151013.05582536.davem@davemloft.net>
To: mpm@selenic.com
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071114225335.GV19691@waste.org>
References: <20071114190501.GA5768@elte.hu>
	<20071114.143938.23516450.davem@davemloft.net>
	<20071114225335.GV19691@waste.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Wed, 14 Nov 2007 16:53:36 -0600

> He hit the bug using SLOB and there are no kmem (or any other) caches
> in SLOB.

That's unfortunate, is there any user tracking facility at
all?
