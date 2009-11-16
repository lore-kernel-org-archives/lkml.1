Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZKPGWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZKPGWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZKPGWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:22:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35114
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbZKPGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:22:41 -0500
Date: Sun, 15 Nov 2009 22:22:57 -0800 (PST)
Message-Id: <20091115.222257.196410609.davem@davemloft.net>
To: mitov@issp.bas.bg
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]remove deprecated and not used: print_mac()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911131958.42263.mitov@issp.bas.bg>
References: <200911131958.42263.mitov@issp.bas.bg>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marin Mitov <mitov@issp.bas.bg>
Date: Fri, 13 Nov 2009 19:58:41 +0200

> The function print_mac in net/ethernet/eth.c is marked __deprecated
> and not used. Remove it.
> 
> The patch is against 2.6.32-rc7.
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

Applied, thanks.
