Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZBCXVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZBCXVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZBCXVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:21:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54840
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbZBCXVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:21:03 -0500
Date: Tue, 03 Feb 2009 15:20:58 -0800 (PST)
Message-Id: <20090203.152058.182816628.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       bfields@fieldses.org, neilb@suse.de, rolandd@cisco.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] sunrpc: fix rdma dependencies
From: David Miller <davem@davemloft.net>
In-Reply-To: <4988C17B.1030902@oracle.com>
References: <200902030112.n131CNiq010549@imap1.linux-foundation.org>
	<4988C17B.1030902@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 03 Feb 2009 14:13:15 -0800

> Fix sunrpc/rdma build dependencies.
> Survives 12 build combinations of INET, IPV6, SUNRPC,
> INFINIBAND, and INFINIBAND_ADDR_TRANS.
 ...
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
