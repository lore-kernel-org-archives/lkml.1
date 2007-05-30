Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbXE3UBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbXE3UBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXE3UB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:01:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38938
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbXE3UB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:01:27 -0400
Date: Wed, 30 May 2007 13:01:40 -0700 (PDT)
Message-Id: <20070530.130140.97293476.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG sparc64] 2.6.22-rc broke X on Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <200705301933.l4UJXIE0023913@alkaid.it.uu.se>
References: <200705301933.l4UJXIE0023913@alkaid.it.uu.se>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Wed, 30 May 2007 21:33:18 +0200 (MEST)

> You were spot on. 2.6.21 + patches up to but not including
> the first one above works. Adding that one gave me a kernel
> that wouldn't boot (hung after "uncompressing kernel").
> Adding the second one above gave me a kernel that booted, but
> where X failed to mmap() the frame buffer as I described.

Thanks for all of your testing.

I'll try to figure this out on one of my Ultra5's here.
