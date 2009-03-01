Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZCAIU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZCAIU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 03:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZCAIUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 03:20:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38396
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbZCAIUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 03:20:37 -0500
Date: Sun, 01 Mar 2009 00:20:19 -0800 (PST)
Message-Id: <20090301.002019.226697924.davem@davemloft.net>
To: christopher.leech@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net headers: export dcbnl.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090227200141.31557.37591.stgit@localhost.localdomain>
References: <20090227200136.31557.53143.stgit@localhost.localdomain>
	<20090227200141.31557.37591.stgit@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Leech <christopher.leech@intel.com>
Date: Fri, 27 Feb 2009 12:01:42 -0800

> The DCB netlink interface is required for building the userspace tools
> available at e1000.sourceforge.net
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>

Also applied, thanks.
