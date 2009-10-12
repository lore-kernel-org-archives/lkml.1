Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZJLFfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZJLFfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZJLFfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:35:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46122
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbZJLFfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:35:07 -0400
Date: Sun, 11 Oct 2009 22:35:02 -0700 (PDT)
Message-Id: <20091011.223502.77690228.davem@davemloft.net>
To: rakib.mullick@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, zbr@ioremap.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] connector: Passing required parameter for function
 cn_add_callback.
From: David Miller <davem@davemloft.net>
In-Reply-To: <b9df5fa10910111944s274207aica39c0e646c10f7a@mail.gmail.com>
References: <b9df5fa10910111944s274207aica39c0e646c10f7a@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>
Date: Mon, 12 Oct 2009 08:44:33 +0600

>   */
> -static void cn_proc_mcast_ctl(struct cn_msg *msg)
> +static void cn_proc_mcast_ctl(struct cn_msg *msg, struct
> netlink_skb_parms *nsp)

Your patches are unusable because your email client corrupts the
patch, here you can see it is splitting up long lines.

Please fix this up and resubmit.
