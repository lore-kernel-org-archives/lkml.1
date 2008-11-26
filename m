Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbYKZXgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbYKZXgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYKZXgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:36:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44438
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbYKZXgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:36:07 -0500
Date: Wed, 26 Nov 2008 15:36:06 -0800 (PST)
Message-Id: <20081126.153606.10175544.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/4 2.6.29] cxgb3 - avoid potential memory leak.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081126203820.4819.17969.stgit@speedy5>
References: <20081126203820.4819.17969.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 26 Nov 2008 12:38:20 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> Add consistency in alloc_ring() parameter checking
> to avoid potential memory leaks.
> alloc_ring() callers are correct fo far.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
