Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZC0Hxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZC0Hxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZC0HxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:53:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbZC0HxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:53:11 -0400
Date: Fri, 27 Mar 2009 00:52:59 -0700 (PDT)
Message-Id: <20090327.005259.56853395.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 1/5] cxgb3: start qset timers when setup
 succeeded
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090327023909.32137.93884.stgit@speedy5>
References: <20090327023909.32137.93884.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 26 Mar 2009 19:39:09 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Start queue set reclaim timers after the queue sets have been
> allocated successfully.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
