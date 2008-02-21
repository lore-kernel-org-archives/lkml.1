Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbYBUQjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbYBUQjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763625AbYBUQjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:39:36 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55568 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755039AbYBUQje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:39:34 -0500
Date: Thu, 21 Feb 2008 17:39:23 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] macb: Fix speed setting
Message-ID: <20080221173923.1301d0c9@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080222.000731.18312290.anemo@mba.ocn.ne.jp>
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
	<20080221151246.6f2044b9@dhcp-252-066.norway.atmel.com>
	<20080222.000731.18312290.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 00:07:31 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> > I'm willing to take your word for it, but some documentation would be
> > really nice...  
> 
> Well, simple grepping drivers/net/phy enlighten us ;)

Yeah, the patch certainly looks correct as far as I can tell.

> Anyway, this patch fixes problem with 10Mbps on AT91SAM9260 board.

Thanks. I'll pass it on.

Haavard
