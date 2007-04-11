Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbXDKHYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbXDKHYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXDKHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:24:33 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56529 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXDKHYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:24:33 -0400
Date: Wed, 11 Apr 2007 11:24:24 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/30] Use menuconfig objects - connector
Message-ID: <20070411072423.GA28888@2ka.mipt.ru>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704102152550.32056@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704102152550.32056@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 11 Apr 2007 11:24:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 09:53:29PM +0200, Jan Engelhardt (jengelh@linux01.gwdg.de) wrote:
> 
> Use menuconfigs instead of menus, so the whole menu can be disabled at        
> once instead of going through all options.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

I have no objections against both connector and w1 changes, feel free to
add my acked-by.
I can push that changes upstream if they will not be picked up as a one
set.

Thanks, Jan.

-- 
	Evgeniy Polyakov
