Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYLPJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYLPJwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYLPJv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:51:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56410
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbYLPJv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:51:56 -0500
Date: Tue, 16 Dec 2008 01:51:57 -0800 (PST)
Message-Id: <20081216.015157.101673618.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.29] cxgb3 - untie strict FW matching
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081215191338.22028.66965.stgit@speedy5>
References: <20081215191338.22028.66965.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 15 Dec 2008 11:13:38 -0800

> The NIC driver can work with mutliple versions of the FW.
> Let the driver load when the embedded FW does not match,
> and the FW update mechanism failed.
> The iWARP module will make its own loading decision.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied, thanks Divy.
