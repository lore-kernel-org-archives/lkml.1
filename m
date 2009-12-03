Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZLCVaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZLCVaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZLCVaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:30:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZLCVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:30:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Patrick Mullaney" <pmullaney@novell.com>
Subject: Re: [PATCH 3/3] macvlan: allow in-kernel modules to create and manage macvlan devices
Date: Thu, 3 Dec 2009 21:28:51 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: bridge@lists.linux-foundation.org, alacrityvm-devel@lists.sourceforge.net,
       kaber@trash.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <4B17C107020000C70007C8CE@soto.provo.novell.com>
In-Reply-To: <4B17C107020000C70007C8CE@soto.provo.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912032128.51929.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/9gFznkh/oAQzJ78a1dQRiGP5x/J772DT34Ms
 Y+JEqp/6HAkqy5U0v9mHTVnYOq3itDDmZ+kH3vZP2SVfyieSgd
 b9YTiUbRgdYHMKl48MLWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 20:45:43 Patrick Mullaney wrote:
> I hope I didn't confuse things by posting:
> 
> netdevice: provide common routine for macvlan and vlan operstate
> management
> 
> again. I offered to send that out patched against net-next-2.6 last
> week and I just got back to following up. I'm fine with you rolling
> them into your series too.

Not at all, thanks for sending that yourself! You did miss the Acked-by
lines from Patrick McHardy and myself though, they should have been
part of your resend. I'll add give you another one then.

	Arnd <><
