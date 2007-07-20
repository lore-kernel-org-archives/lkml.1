Return-Path: <linux-kernel-owner+w=401wt.eu-S939843AbXGTAvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939843AbXGTAvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939255AbXGTAtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:49:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42110
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S939383AbXGTAtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:49:42 -0400
Date: Thu, 19 Jul 2007 17:49:41 -0700 (PDT)
Message-Id: <20070719.174941.11597953.davem@davemloft.net>
To: shannon.nelson@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jeff@garzik.org,
       dan.j.williams@intel.com, christopher.leech@intel.com,
       peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH 2/7] I/OAT: Rename the source file
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070720004457.13564.78052.stgit@localhost.localdomain>
References: <20070720004403.13564.14294.stgit@localhost.localdomain>
	<20070720004457.13564.78052.stgit@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shannon Nelson <shannon.nelson@intel.com>
Date: Thu, 19 Jul 2007 17:44:57 -0700

> Rename the ioatdma.c file in preparation for splitting into multiple files,
> which will allow for easier adding new functionality.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
