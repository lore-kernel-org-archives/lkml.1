Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZDTJJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZDTJJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZDTJIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:08:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59074
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbZDTJIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:08:37 -0400
Date: Mon, 20 Apr 2009 02:08:25 -0700 (PDT)
Message-Id: <20090420.020825.244829541.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 3/4] cxgb3: Fix potential msi-x vector leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090417222122.8537.43636.stgit@speedy5>
References: <20090417222122.8537.43636.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Fri, 17 Apr 2009 15:21:22 -0700

> Release vectors when a MSI-X allocation fails.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
