Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbYBTAZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbYBTAZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763039AbYBTAZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:25:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52045
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762866AbYBTAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:25:04 -0500
Date: Tue, 19 Feb 2008 16:25:41 -0800 (PST)
Message-Id: <20080219.162541.54837477.davem@davemloft.net>
To: bunk@kernel.org
Cc: ericvh@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] net/9p/trans_virtio.c: kmalloc() enough memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080220001410.GX31955@cs181133002.pp.htv.fi>
References: <20080220001410.GX31955@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 20 Feb 2008 02:14:10 +0200

> The Coverity checker spotted that less memory than required was allocated.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
