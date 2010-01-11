Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598Ab0AKSrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0AKSrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509Ab0AKSrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:47:45 -0500
Received: from kroah.org ([198.145.64.141]:59719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0AKSrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:47:45 -0500
Date: Mon, 11 Jan 2010 10:47:57 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: linux-kernel@vger.kernel.org, drivers_staging@kernel-bugs.osdl.org
Subject: Re: [PATCH] HTC Dream camera, not need sizeof
Message-ID: <20100111184757.GA30222@kroah.com>
References: <201001112108.02634.pavel@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001112108.02634.pavel@pavlinux.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 09:08:02PM +0300, Pavel Vasilyev wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=14825
> 
> Kernel version: git master (2.6.33-rc3-git3) 
> 
> 
> Description:
> 
> sizeof(extlen), always will be sizeof( unit32_t) or 4
> It seems that something is wrong?!?! 

Can I get a "Signed-off-by:" for this patch so that I can apply it to
the tree?

thanks,

greg k-h
