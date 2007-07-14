Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbXGNUEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbXGNUEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761136AbXGNUEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:04:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40983
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760924AbXGNUEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:04:33 -0400
Date: Sat, 14 Jul 2007 13:04:35 -0700 (PDT)
Message-Id: <20070714.130435.126576296.davem@davemloft.net>
To: kaber@trash.net
Cc: nix.or.die@googlemail.com, linux-kernel@vger.kernel.org,
       kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org
Subject: Re: [PATCH] NET_CLS_RSVP6 should depend on IPV6
From: David Miller <davem@davemloft.net>
In-Reply-To: <4698ED6E.6020502@trash.net>
References: <4698A7B6.1030302@googlemail.com>
	<4698ED6E.6020502@trash.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 14 Jul 2007 17:36:14 +0200

> Gabriel C wrote:
> > cls_rsvp6 only works with IPV6 enabled kernels and IMO it should depends
> > on IPV6.
> 
> 
> I can't see any functional dependency on IPv6, what exactly are you
> refering to? People might want to use it on a bridge for example
> without having IPv6 running locally.

That's my feeling as well.
