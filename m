Return-Path: <linux-kernel-owner+w=401wt.eu-S1763008AbXGMHhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763008AbXGMHhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXGMHhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:37:24 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:58535 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbXGMHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:37:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=TacM7Y/JGIYJ/XTFew/kKo0aCTcbwRRz0OXa1irqGRo9phTY2lGr2ezD/h3gN
	1YYggdD/G9ZUSLv2x378Js4/Q==
Date: Fri, 13 Jul 2007 09:37:20 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Donoghue <john.donoghue@ieee.org>
Subject: Re: [2.6 patch] EP93XX_ETH must select MII
Message-ID: <20070713073720.GC19718@xi.wantstofly.org>
References: <20070713001208.GX3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713001208.GX3492@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 02:12:08AM +0200, Adrian Bunk wrote:

> From: John Donoghue <john.donoghue@ieee.org>
> 
> CONFIG_EP93XX_ETH=y, CONFIG_MII=n results in an obvious link error.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
