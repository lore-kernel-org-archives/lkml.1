Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbZC0Hyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbZC0Hyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZC0Hxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:53:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36374
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbZC0Hx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:53:28 -0400
Date: Fri, 27 Mar 2009 00:53:15 -0700 (PDT)
Message-Id: <20090327.005315.141636404.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 4/5] cxgb3: differentiate portx and Tx channels
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090327023924.32137.21445.stgit@speedy5>
References: <20090327023909.32137.93884.stgit@speedy5>
	<20090327023924.32137.21445.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 26 Mar 2009 19:39:24 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Separate ports from H/W Tx channels.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
