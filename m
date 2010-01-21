Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412Ab0AUNIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0AUNIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187Ab0AUNIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:08:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51738
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575Ab0AUNIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:08:11 -0500
Date: Thu, 21 Jan 2010 05:08:21 -0800 (PST)
Message-Id: <20100121.050821.80020283.davem@davemloft.net>
To: julia@diku.dk
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/9] net/sctp: Eliminate useless code
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1001211148310.13529@ask.diku.dk>
References: <Pine.LNX.4.64.1001211121500.13529@ask.diku.dk>
	<20100121.024337.57448535.davem@davemloft.net>
	<Pine.LNX.4.64.1001211148310.13529@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 21 Jan 2010 11:49:10 +0100 (CET)

> Is the new one better than the old one?  Because in my local copies, they 
> are the same...

The new one worked and I applied it.
