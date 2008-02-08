Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbYBHCLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbYBHCLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYBHCL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:11:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45465
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYBHCL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:11:28 -0500
Date: Thu, 07 Feb 2008 18:11:59 -0800 (PST)
Message-Id: <20080207.181159.160811975.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [IPV6] Minor cleanup: remove unused definitions in
 net/ip6_fib.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0802070823y7038fcedga27cba4a9bb35731@mail.gmail.com>
References: <eb3ff54b0802070823y7038fcedga27cba4a9bb35731@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Thu, 7 Feb 2008 18:23:58 +0200

> Hi,
> 
> This patch removes some unused definitions and one method typedef
> declaration (f_pnode)
> in include/net/ip6_fib.h, as they are not used in the kernel.
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied, thanks.
