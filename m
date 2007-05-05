Return-Path: <linux-kernel-owner+w=401wt.eu-S1423705AbXEEAsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423705AbXEEAsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 20:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423710AbXEEAsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 20:48:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423705AbXEEAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 20:48:18 -0400
Date: Fri, 4 May 2007 17:48:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
Message-Id: <20070504174811.f564ffb3.akpm@linux-foundation.org>
In-Reply-To: <1178215277.4369.6.camel@amdx2.microgate.com>
References: <1178215277.4369.6.camel@amdx2.microgate.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 13:01:17 -0500
Paul Fulghum <paulkf@microgate.com> wrote:

> Add compat_ioctl handler to synclink_gt driver.

i386 allmodconfig:

make[3]: *** No rule to make target `/usr/src/devel/usr/include/linux/.check.synclink.h', needed by `__headerscheck'.  Stop.

I got tired of this patch - I think I'll drop it.
