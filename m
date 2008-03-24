Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYCXFSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYCXFSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 01:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYCXFSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 01:18:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47635
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbYCXFSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 01:18:04 -0400
Date: Sun, 23 Mar 2008 22:18:04 -0700 (PDT)
Message-Id: <20080323.221804.248467261.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/igmp.h - remove duplicate include
From: David Miller <davem@davemloft.net>
In-Reply-To: <1205106940.656.103.camel@localhost>
References: <1205106940.656.103.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 09 Mar 2008 16:55:40 -0700

> Removed duplicate #include <linux/skbuff.h>	
> Combined #ifdef __KERNEL__ blocks
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
