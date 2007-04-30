Return-Path: <linux-kernel-owner+w=401wt.eu-S1423069AbXD3G0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423069AbXD3G0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 02:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423070AbXD3G0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 02:26:17 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51180 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423069AbXD3G0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 02:26:16 -0400
Date: Mon, 30 Apr 2007 08:25:41 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Li Yu <raise.sail@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
Subject: Re: [PATCH] usb/hid:The HID Simple Driver Patches 0.5.1
In-Reply-To: <200704301419090949930@gmail.com>
Message-ID: <Pine.LNX.4.64.0704300822530.20657@twin.jikos.cz>
References: <200704301419090949930@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Li Yu wrote:

> This patch set include :
> 	1. usb/hid: The HID Simple Driver Interface 0.5.0 (core)
> 	2. usb/hid:Microsoft Natural Ergonomic Keyboard 4000 Driver 0.5.1
> 	3. Some related kbuild changes.
> The changelog since 0.5.0:
> 	1. The parameter ascii_keycode of usbnek4k.ko is on default. so 
>          the five custom keys can work without any care.
> 	2. Add the parameter zoom_scroll of usbnek4k.ko, so we can use 
>          zoomin/zoomout handlers as mouse scrollwheel. this is on 
>          default too.

Hi Li,

is there any chance that you rather split up the hid bus patch you have 
been working on recently into independent reviewable patches instead, as 
we were discussing it previously?

Thanks,

-- 
Jiri Kosina
