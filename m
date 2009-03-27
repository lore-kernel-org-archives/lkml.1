Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbZC0XBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbZC0XBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZC0XBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:01:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49365
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbZC0XBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:01:19 -0400
Date: Fri, 27 Mar 2009 16:01:07 -0700 (PDT)
Message-Id: <20090327.160107.184169637.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
From: David Miller <davem@davemloft.net>
In-Reply-To: <49CD0368.2010805@oracle.com>
References: <20090327231924.4e4168c5.sfr@canb.auug.org.au>
	<49CD0368.2010805@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 27 Mar 2009 09:48:40 -0700

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090326:
> 
> 
> with CONFIG_IPV6=n:
> 
> ERROR: "__ipv6_addr_type" [net/netfilter/xt_cluster.ko] undefined!
> 
> config attached.

Patrick and netfilter folks, please have a look, thanks!
