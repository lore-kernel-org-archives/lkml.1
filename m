Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXGXPbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXGXPbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbXGXPbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:31:34 -0400
Received: from stinky.trash.net ([213.144.137.162]:60197 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbXGXPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:31:30 -0400
Message-ID: <46A61B32.90302@trash.net>
Date: Tue, 24 Jul 2007 17:30:58 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       David S Miller <davem@davemloft.net>,
       Harald Welte <laforge@netfilter.org>,
       netfilter-devel@lists.netfilter.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       James Morris <jmorris@redhat.com>,
       Netfilter Core Team <coreteam@netfilter.org>,
       Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH][30/37] Clean up duplicate includes in net/netfilter/
References: <200707211703.47827.jesper.juhl@gmail.com>
In-Reply-To: <200707211703.47827.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> This patch cleans up duplicate includes in
> 	net/netfilter/


I've queued this one and the bridge-netfilter patch (27/37), thanks
Jesper.
