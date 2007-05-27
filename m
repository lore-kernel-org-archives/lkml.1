Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbXE0Wpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbXE0Wpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXE0WpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:45:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49010
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbXE0WpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:45:24 -0400
Date: Sun, 27 May 2007 15:45:31 -0700 (PDT)
Message-Id: <20070527.154531.39158567.davem@davemloft.net>
To: adaplas@gmail.com
Cc: akpm@osdl.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] fbdev: Detect primary display device
From: David Miller <davem@davemloft.net>
In-Reply-To: <465952CD.2040409@gmail.com>
References: <465952CD.2040409@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Antonino A. Daplas" <adaplas@gmail.com>
Date: Sun, 27 May 2007 17:43:41 +0800

> Add function helper, fb_is_display_device().  Given struct fb_info, it will
> return a nonzero value if the device is the primary display.
> 
> Currently, only the i386 is supported, other platforms only have stubs. For 
> the i386, the function checks for the IORESOURCE_ROM_SHADOW flag.
> 
> Signed-off-by: Antonino Daplas <adaplas@gmail.com>

Thank you so much for following up on this work.

I'll try to get the sparc side implemented some time this
coming week.

Thanks again.
