Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYLUU73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYLUU73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYLUU6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:58:31 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43075 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYLUU6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:58:30 -0500
Date: Sun, 21 Dec 2008 20:58:28 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jaswinder Singh <jaswinderlinux@gmail.com>
cc: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jaswinder Singh <jaswinder@infradead.org>
Subject: Re: [PATCH] radeon_cp: use request_firmware
In-Reply-To: <3f9a31f40812191223g72b8a1eey2780f8e1a0ebf7aa@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0812212056060.8861@skynet.skynet.ie>
References: <1218095497.4016.3.camel@jaswinder.satnam> <3f9a31f40812191223g72b8a1eey2780f8e1a0ebf7aa@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Is available at
> http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commit;h=3a911a216742e4ab998f3281409d46a62f252716
> 
> 
> Please let me know, should I need to resend this patch for :
> 1. git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> OR
> 2. git kernel.org:/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

How much testing has this seen on what range of cards and on what 
architectures? I'd like some success stories from people using this patch.
Is Debian shipping it?

Its do think firmware patches are stupid (I do), but I'm not against 
applying them if they are proven working.

Dave.
