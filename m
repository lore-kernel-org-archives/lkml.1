Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZJQBDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZJQBDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 21:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZJQBDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 21:03:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43306
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZJQBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 21:03:47 -0400
Date: Fri, 16 Oct 2009 18:04:09 -0700 (PDT)
Message-Id: <20091016.180409.204538933.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901E24569@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901E24569@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Fri, 16 Oct 2009 19:30:02 -0400

> The symbol ic_dev_xid is only used locally to track the device being
> configured.  As such, it should be static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

1) Your patch doesn't apply to current sources.

2) You need to CC: all networking patch submissions to
   netdev@vger.kernel.org so that your patch gets properly
   tracked at http://patchwork.ozlabs.org/project/netdev/list

Thanks.
