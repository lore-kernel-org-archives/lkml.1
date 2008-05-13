Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbYEMISw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbYEMISw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYEMISf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:18:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38098
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756641AbYEMISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:18:34 -0400
Date: Tue, 13 May 2008 01:18:28 -0700 (PDT)
Message-Id: <20080513.011828.193690369.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for .26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080513055623.GA16928@havoc.gtf.org>
References: <20080513055623.GA16928@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Tue, 13 May 2008 01:56:23 -0400

> 
> Notes:
> - lotsa LOC change in sfc, but it's a new driver, so no possible
>   regressions
> 
> - we add some non-net exports required for ehea (drivers/base/memory.c)

Pulled, thanks a lot Jeff.
