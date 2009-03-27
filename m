Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZC0Hy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZC0Hy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZC0HxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:53:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36369
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755677AbZC0HxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:53:23 -0400
Date: Fri, 27 Mar 2009 00:53:10 -0700 (PDT)
Message-Id: <20090327.005310.57231679.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 3/5] cxgb3: use resource_size_t for mmio
 declarations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090327023919.32137.81488.stgit@speedy5>
References: <20090327023909.32137.93884.stgit@speedy5>
	<20090327023919.32137.81488.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 26 Mar 2009 19:39:19 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Use resource_size_t to declare mmio start and len variables.
> Print PEX error register after EEH resumed.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
