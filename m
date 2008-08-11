Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYHKUwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYHKUwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbYHKUvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:51:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50671
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753647AbYHKUvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:51:47 -0400
Date: Mon, 11 Aug 2008 13:51:48 -0700 (PDT)
Message-Id: <20080811.135148.153377940.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: mingo@elte.hu, alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
       randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net, wd.c: fix undefined reference to `NS8390p_init'
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A00AB5.1030108@pobox.com>
References: <20080807102931.1bb0607d@lxorguk.ukuu.org.uk>
	<20080811091105.GA8141@elte.hu>
	<48A00AB5.1030108@pobox.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Mon, 11 Aug 2008 05:47:33 -0400

> DaveM should have it AFAIK, I'll double-check and make sure it got in 
> somewhere.

I pushed your most recent merge of driver fixes to Linus so if it's
not in his tree I haven't seen it yet. :-)

