Return-Path: <linux-kernel-owner+w=401wt.eu-S968811AbXILO4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968811AbXILO4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967329AbXILOzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:55:54 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:57294
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966391AbXILOzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:55:53 -0400
Date: Wed, 12 Sep 2007 07:55:41 -0700 (PDT)
Message-Id: <20070912.075541.26980120.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-2.6.24] cxgb3 - napi update
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070909070917.27016.76853.stgit@speedy5>
References: <20070909070917.27016.76853.stgit@speedy5>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sun, 09 Sep 2007 00:09:17 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Embed napi_struct directly into sge_qset.
> Use napi_schedule/napi_complete.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Patch applied, thanks a lot!
