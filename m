Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbXGVCUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbXGVCUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXGVCUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:20:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49169
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbXGVCUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:20:44 -0400
Date: Sat, 21 Jul 2007 19:20:43 -0700 (PDT)
Message-Id: <20070721.192043.68038091.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make sparc32 PAGE_SHARED a read-mostly variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1ICO7t-0001yp-RO@ZenIV.linux.org.uk>
References: <E1ICO7t-0001yp-RO@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jul 2007 00:12:41 +0100

> same scheme as for sparc64, same rationale
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks.
