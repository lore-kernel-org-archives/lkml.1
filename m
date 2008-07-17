Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYGQDOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYGQDOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbYGQDNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:13:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41707
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbYGQDNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:13:53 -0400
Date: Wed, 16 Jul 2008 20:13:52 -0700 (PDT)
Message-Id: <20080716.201352.167490585.davem@davemloft.net>
To: will.newton@imgtec.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       will.newton@gmail.com
Subject: Re: [PATCH] net/ipv4/tcp.c: Fix use of PULLHUP instead of POLLHUP
 in comments.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216222235-11338-1-git-send-email-will.newton@imgtec.com>
References: <1216222235-11338-1-git-send-email-will.newton@imgtec.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@imgtec.com>
Date: Wed, 16 Jul 2008 16:30:35 +0100

> Change PULLHUP to POLLHUP in tcp_poll comments and clean up another
> comment for grammar and coding style.
> 
> Signed-off-by: Will Newton <will.newton@gmail.com>

Applied, thanks.
