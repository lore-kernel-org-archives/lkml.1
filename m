Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYLSG4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYLSG4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 01:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYLSG4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 01:56:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35081
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbYLSG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 01:56:31 -0500
Date: Thu, 18 Dec 2008 22:56:32 -0800 (PST)
Message-Id: <20081218.225632.113687804.davem@davemloft.net>
To: kxie@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu,
       James.Bottomley@HansenPartnership.com, divy@chelsio.com,
       swise@opengridcomputing.com
Subject: Re: [PATCH v3 2.6.29] cxgb3 - manage private iSCSI IP address
From: David Miller <davem@davemloft.net>
In-Reply-To: <200812190243.mBJ2hPZY008757@localhost.localdomain>
References: <200812190243.mBJ2hPZY008757@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karen Xie <kxie@chelsio.com>
Date: Thu, 18 Dec 2008 18:43:25 -0800

> [PATCH v3 2.6.29] cxgb3 - manage private iSCSI IP address
> 
> The accelerated iSCSI traffic could use a private IP address unknown to the OS:
> - The IP address is required in both drivers to manage ARP requests and connection set up.
> - Added an control call to retrieve the ip address.
> - Reply to ARP requests dedicated to the private IP address.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> Signed-off-by: Karen Xie <kxie@chelsio.com>

Patch applied, thank you.
