Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbXITEMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbXITEMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 00:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbXITEMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 00:12:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47877 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175AbXITEMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 00:12:16 -0400
Message-ID: <46F1F302.4050905@pobox.com>
Date: Thu, 20 Sep 2007 00:11:46 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET_SB1250_MAC: Rename to SB1250_MAC
References: <Pine.LNX.4.64N.0709141158010.1926@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0709141158010.1926@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  Rename NET_SB1250_MAC to SB1250_MAC to follow the convention.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  The NET prefix seems to be used mainly for device groups (NET_ISA, 
> NET_VENDOR_*, etc.) rather than single drivers and adds no information.  I 
> suggest it to be removed.
> 
>  Depends on "patch-netdev-2.6.23-rc6-20070913-sb1250-mac-kconfig-0".

applied


