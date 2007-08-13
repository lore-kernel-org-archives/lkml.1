Return-Path: <linux-kernel-owner+w=401wt.eu-S941252AbXHMKso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941252AbXHMKso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967174AbXHMGge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53405
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967338AbXHMGga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:30 -0400
Date: Sun, 12 Aug 2007 23:36:30 -0700 (PDT)
Message-Id: <20070812.233630.00455011.davem@davemloft.net>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [374/2many] MAINTAINERS - PCNET32 NETWORK DRIVER
From: David Miller <davem@davemloft.net>
In-Reply-To: <46bffb4c.nrqicrPs7IJXlgQ0%joe@perches.com>
References: <46bffb4c.nrqicrPs7IJXlgQ0%joe@perches.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, 374 patches is just rediculious.

So many patches eats up an enormous amount of mailing list resources,
and for these patches in particular there are few reasons to split
them up at all.  The fact that the split up landed you at 300+ patches
is a very good indication of that.
