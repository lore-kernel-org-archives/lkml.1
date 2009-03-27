Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZC0Hx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZC0Hx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbZC0HxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:53:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36365
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755648AbZC0HxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:53:16 -0400
Date: Fri, 27 Mar 2009 00:53:04 -0700 (PDT)
Message-Id: <20090327.005304.267479164.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 2/5] cxgb3: sge setup fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090327023914.32137.29655.stgit@speedy5>
References: <20090327023909.32137.93884.stgit@speedy5>
	<20090327023914.32137.29655.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 26 Mar 2009 19:39:14 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Enable timestamps, update delayed ack threshold for iSCSI/iWARP traffic
> Remove the len flag in Tx requests. It might corrupt offload trace packets.
> Update SGE context setup to avoid potential H/W misprogrammation.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
