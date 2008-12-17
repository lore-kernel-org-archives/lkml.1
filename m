Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759337AbYLQIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYLQIc5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYLQIcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:32:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51512
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbYLQIcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:32:42 -0500
Date: Wed, 17 Dec 2008 00:32:44 -0800 (PST)
Message-Id: <20081217.003244.67002510.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xemul@openvz.org
Subject: Re: [PATCH] net: ppp_generic - use idr technique instead of
 cardmaps
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081216192000.GF26390@localhost>
References: <20081216192000.GF26390@localhost>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Tue, 16 Dec 2008 22:20:00 +0300

> Here is an attempt to convert cardmaps into ird.
> I would really appreciate any feedback.
> 
> I've tested ird under qemu (by some hacks not real ppp connection)
> so real loadings could reveal problems with the patch - review
> carefully please. (i'm not subcribed for netdev list CC me).
> 
> Any comments are _quite_ welcome! Paul?

This looks good to me.

I'll apply this to net-next-2.6, thanks!

