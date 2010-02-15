Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0BOGfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:35:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34682
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab0BOGfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:35:46 -0500
Date: Sun, 14 Feb 2010 22:36:01 -0800 (PST)
Message-Id: <20100214.223601.10215200.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] net: Fix first line of kernel-doc for a few
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266157154.10567.15.camel@localhost>
References: <1266157055.10567.13.camel@localhost>
	<1266157154.10567.15.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 14 Feb 2010 14:19:14 +0000

> The function name must be followed by a space, hypen, space, and a
> short description.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Looks good, applied to net-next-2.6, thanks Ben.
