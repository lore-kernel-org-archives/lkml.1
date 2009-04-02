Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZDBHyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZDBHyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZDBHyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:54:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56884
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbZDBHyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:54:13 -0400
Date: Thu, 02 Apr 2009 00:54:02 -0700 (PDT)
Message-Id: <20090402.005402.205465797.davem@davemloft.net>
To: kaber@trash.net
Cc: r000n@r000n.net, dada1@cosmosbay.com, shemminger@vyatta.com,
       linux-kernel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free
 counters"
From: David Miller <davem@davemloft.net>
In-Reply-To: <49D0B628.5000501@trash.net>
References: <49D075A3.1050202@cosmosbay.com>
	<20090330145031.2dfd854e@desktop.r000n.info>
	<49D0B628.5000501@trash.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 30 Mar 2009 14:08:08 +0200

> Thanks indeed Eric :) Dave, please apply.
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

Applied, thanks everyone.
