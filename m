Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYFREIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYFREIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 00:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYFREIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 00:08:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52166
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751579AbYFREIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 00:08:02 -0400
Date: Tue, 17 Jun 2008 21:08:03 -0700 (PDT)
Message-Id: <20080617.210803.190930256.davem@davemloft.net>
To: wcang@nav6.org
Cc: maxk@qualcomm.com, steve.zabele@baesystems.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: Proper handling of IPv6 header in tun driver when
 TUN_NO_PI is set
From: David Miller <davem@davemloft.net>
In-Reply-To: <48586F4B.4060404@nav6.org>
References: <48499C32.6070703@qualcomm.com>
	<20080617.163205.160864233.davem@davemloft.net>
	<48586F4B.4060404@nav6.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ang Way Chuang <wcang@nav6.org>
Date: Wed, 18 Jun 2008 10:13:31 +0800

> David Miller wrote:
> > From: Max Krasnyanskiy <maxk@qualcomm.com>
> > Date: Fri, 06 Jun 2008 13:21:06 -0700
> > 
> >> Acked-by: Max Krasnyansky <maxk@qualcomm.com>
> >>
> >> Dave, can you please add this patch to your tree.
> > 
> > I can't, the patch is severely whitespace damaged.
> > 
> Resend. Hopefully Thunderbird won't screw this time.

Same problem, tabs were transformed into spaces, and
lines composed of only whitespace were transformed into
empty lines.

This is frustrating enough, I'm just going to fix this up
by hand for you, but please get your shit straight for next
time because I won't do this twice.

Thanks.
