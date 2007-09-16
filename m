Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbXIPXjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbXIPXjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 19:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbXIPXjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 19:39:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38142
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753805AbXIPXji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 19:39:38 -0400
Date: Sun, 16 Sep 2007 16:39:37 -0700 (PDT)
Message-Id: <20070916.163937.103775147.davem@davemloft.net>
To: crquan@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: Re: [PATCH] net/ipv4/af_inet.c: use ARRAY_SIZE macro from kernel.h
 instead
From: David Miller <davem@davemloft.net>
In-Reply-To: <11887091471748-git-send-email-crquan@gmail.com>
References: <11887091471748-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Sun,  2 Sep 2007 12:59:07 +0800

> Signed-off-by: Denis Cheng <crquan@gmail.com>

Applied to net-2.6.24, thanks!
