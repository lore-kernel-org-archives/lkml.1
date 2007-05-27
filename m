Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbXE0Woz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbXE0Woz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXE0Wos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:44:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49003
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbXE0Wor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:44:47 -0400
Date: Sun, 27 May 2007 15:44:54 -0700 (PDT)
Message-Id: <20070527.154454.51856593.davem@davemloft.net>
To: adaplas@gmail.com
Cc: akpm@osdl.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] [TRY 2] fbdev: Move arch-specific bits to their
 respective subdirectories
From: David Miller <davem@davemloft.net>
In-Reply-To: <4659530E.40102@gmail.com>
References: <4659530E.40102@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Antonino A. Daplas" <adaplas@gmail.com>
Date: Sun, 27 May 2007 17:44:46 +0800

> Move arch-specific bits of fb_mmap() to their respective subdirectories
> 
> Signed-off-by: Antonino Daplas <adaplas@gmail.com>

The sparc and sparc64 bits look good.

Acked-by: David S. Miller <davem@davemloft.net>
