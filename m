Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYKVFqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYKVFqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 00:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYKVFqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 00:46:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39077
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbYKVFqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 00:46:38 -0500
Date: Fri, 21 Nov 2008 21:46:38 -0800 (PST)
Message-Id: <20081121.214638.190162060.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Pull request] WAN aka generic HDLC (net-next)
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3ljvcqzhl.fsf@maximus.localdomain>
References: <m3ljvcqzhl.fsf@maximus.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 22 Nov 2008 03:13:42 +0100

> Can you pull my WAN tree into net-next, please?
> Freshly rebased, with duplicate "dev->priv" commits removed, this is
> basically:
> - updates to Hitachi/Renesas SCA/SCA-II-based drivers (including
>   hd6457x.c split into hd64570.c and hd64572.c)
> - the second=last part of syncppp conversion (all drivers are already
>   using hdlc_ppp)
> - smaller things

Pulled, thanks Krzysztof.
