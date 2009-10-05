Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZJEHMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZJEHMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZJEHMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:12:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54622
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538AbZJEHMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:12:31 -0400
Date: Mon, 05 Oct 2009 00:12:26 -0700 (PDT)
Message-Id: <20091005.001226.120933767.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 19/21] drivers/net/bonding/: : use pr_fmt
From: David Miller <davem@davemloft.net>
In-Reply-To: <ec7e258261ac67ba496f96d04c270cf89fc24deb.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
	<cover.1254701151.git.joe@perches.com>
	<ec7e258261ac67ba496f96d04c270cf89fc24deb.1254701151.git.joe@perches.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun,  4 Oct 2009 17:53:46 -0700

> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Remove DRV_NAME from pr_<level>s
> Consolidate long format strings
> Remove some extra tab indents
> Remove some unnecessary ()s from pr_<level>s arguments
> Align pr_<level> arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to net-next-2.6
