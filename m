Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYDRGUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYDRGUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYDRGUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:20:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56025
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbYDRGUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:20:22 -0400
Date: Thu, 17 Apr 2008 23:20:21 -0700 (PDT)
Message-Id: <20080417.232021.72082620.davem@davemloft.net>
To: kaber@trash.net
Cc: 12o3l@tiscali.nl, hadi@cyberus.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: catch signed nla_len() retval in tcf_simp_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4806D847.2030806@trash.net>
References: <4806C501.20300@tiscali.nl>
	<20080416.213712.78410382.davem@davemloft.net>
	<4806D847.2030806@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 17 Apr 2008 06:55:35 +0200

> The change is also unnecessary because the attribute was
> already validated and the length can not be less than zero.
> 
> This patch changes it to only check for zero length.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Even though there have been discussions to do other things,
this patch moves things in the forward direction so I have
applied it.

Thanks.

