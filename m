Return-Path: <linux-kernel-owner+w=401wt.eu-S1763974AbXESS7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974AbXESS7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbXESS7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:59:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49492
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756765AbXESS7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:59:36 -0400
Date: Sat, 19 May 2007 11:59:38 -0700 (PDT)
Message-Id: <20070519.115938.112265827.davem@davemloft.net>
To: dsaxena@plexity.net
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add ip6_tunnel.h to headers_install
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070519174857.GA1199@plexity.net>
References: <20070519174857.GA1199@plexity.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Saxena <dsaxena@plexity.net>
Date: Sat, 19 May 2007 10:48:57 -0700

> 
> The Mobile IPv6 package (http://www.mobile-ipv6.org/software/) needs
> this header file to build the tunnelctl component. The header
> already looks sanitized so is safe to export.
> 
> Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

I know this is really brain twister for folks to figure out
and remember, but could you at least CC: netdev@vger when
posting networking related patches, thank you.

I'll apply this patch, thanks.
