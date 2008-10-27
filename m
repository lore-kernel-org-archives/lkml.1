Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYJ0Tij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYJ0Tij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYJ0Ti3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:38:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53366
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbYJ0Ti2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:38:28 -0400
Date: Mon, 27 Oct 2008 12:38:05 -0700 (PDT)
Message-Id: <20081027.123805.134354592.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: johannes@sipsolutions.net, anders@anduras.de, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv2] printk: add the %pM, %p4, %p6 format specifiers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1225124904.5440.1.camel@brick>
References: <1225067465.5672.1.camel@brick>
	<1225090765.3746.7.camel@johannes.berg>
	<1225124904.5440.1.camel@brick>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 27 Oct 2008 09:28:24 -0700

> On Mon, 2008-10-27 at 07:59 +0100, Johannes Berg wrote:
> 
> > Also can you keep mac/ip address patches split up so we can use my
> > version of the mac address patch (it's already well-tested)?
> > 
> 
> Sure.  I'll build on top.

So I'll wait for Harvey's "v3" of this patch, and once I have that in
the net-next-2.6 tree I'll start adding Johannes's conversions on top.
