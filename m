Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYKYVpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYKYVpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYKYVmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:42:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40025
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754880AbYKYVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:42:16 -0500
Date: Tue, 25 Nov 2008 13:42:15 -0800 (PST)
Message-Id: <20081125.134215.146717314.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: alan@lxorguk.ukuu.org.uk, kamalesh@linux.vnet.ibm.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, mel@csn.ul.ie, shemminger@linux-foundation.org
Subject: Re: [BUILD_FAILURE] linux-next: 20081125 - 8390 network driver
 build fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <492C5B52.6090803@oracle.com>
References: <492C562E.9090302@oracle.com>
	<20081125195756.12317499@lxorguk.ukuu.org.uk>
	<492C5B52.6090803@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 25 Nov 2008 12:08:50 -0800

> Looks like it's due to CONFIG_COMPAT_NET_DEV_OPS.

Right, I've asked Stephen Hemminger to fix this.

> Dave, no need to drop my hp-plus driver patch.

Yes, I knew this :)
