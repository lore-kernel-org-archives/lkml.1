Return-Path: <linux-kernel-owner+w=401wt.eu-S964931AbXC0GUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbXC0GUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXC0GUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:20:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57278 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbXC0GUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:20:50 -0400
Date: Mon, 26 Mar 2007 23:20:42 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>, Ben Dooks <ben-linux@fluff.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Linux 2.6.21-rc5
Message-ID: <20070327062042.GA29855@kroah.com>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326221731.f4792260.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326221731.f4792260.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 10:17:31PM -0800, Andrew Morton wrote:
> 
> I have a few fixes here which belong to subsystem trees, which were missed
> by the maintainers and which we probably want to get into 2.6.21.
> 
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/pci-set-pci=bfsort-for-poweredge-r900.patch

Already in Linus's tree.

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch

I'd prefer to wait until 2.6.22 for this one, I've had too many odd
reports of problems in this area, and since no one has reported this
issue, it's not a real rush at all.

thanks,

greg k-h
