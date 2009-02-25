Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbZBYIMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbZBYIMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZBYIMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:12:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42571
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbZBYIMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:12:22 -0500
Date: Wed, 25 Feb 2009 00:12:03 -0800 (PST)
Message-Id: <20090225.001203.123398134.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com
Subject: Re: linux-next: Tree for February 24 (netdev/hp-plus build error)
From: David Miller <davem@davemloft.net>
In-Reply-To: <49A4248F.6090202@oracle.com>
References: <20090224212949.0dacb59f.sfr@canb.auug.org.au>
	<49A4248F.6090202@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 24 Feb 2009 08:47:11 -0800

> ERROR: "__alloc_ei_netdev" [drivers/net/hp-plus.ko] undefined!
> 
> config attached.

Grumble... I'll take a look, thanks.
