Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZEUDwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZEUDwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZEUDwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:52:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45583
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480AbZEUDwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:52:22 -0400
Date: Wed, 20 May 2009 20:52:21 -0700 (PDT)
Message-Id: <20090520.205221.36274904.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next] cxgb3: set phy's mdio dev before the phy init
 sequence
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090521015602.1905.98758.stgit@speedy5>
References: <20090521015602.1905.98758.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 20 May 2009 18:56:02 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> mdio's dev field needs to be set before mdio ops occur.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
