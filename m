Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbXERKYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbXERKYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXERKYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:24:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32932
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbXERKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:24:18 -0400
Date: Fri, 18 May 2007 03:24:20 -0700 (PDT)
Message-Id: <20070518.032420.32346460.davem@davemloft.net>
To: xemul@sw.ru
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 10/15] Make some network-related proc files use
 seq_list_xxx helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <464D7789.5030306@sw.ru>
References: <464D6E87.7060605@sw.ru>
	<464D7789.5030306@sw.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelianov <xemul@sw.ru>
Date: Fri, 18 May 2007 13:53:13 +0400

> This includes /proc/net/protocols, /proc/net/rxrpc_calls
> and /proc/net/rxrpc_connections files.
> 
> All three need seq_list_start_head to show some header.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>

Acked-by: David S. Miller <davem@davemloft.net>
