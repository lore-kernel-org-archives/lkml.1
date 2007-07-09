Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXGIV1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXGIV1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbXGIV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:27:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbXGIV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:27:36 -0400
Date: Mon, 9 Jul 2007 14:27:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] misc patches
Message-Id: <20070709142701.24566a19.akpm@linux-foundation.org>
In-Reply-To: <20070709142417.f3acdfcc.rdunlap@xenotime.net>
References: <200707081754.03824.eike-kernel@sf-tec.de>
	<20070709142417.f3acdfcc.rdunlap@xenotime.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 14:24:17 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Sun, 8 Jul 2007 17:53:56 +0200 Rolf Eike Beer wrote:
> 
> > This are some random patches I've lying around here. They are not related to 
> > each other
> > 
> > 1) Use kcalloc() in drivers/video/aty/atyfb_base.c
> > 2) Initialize filp->private_data only once in em28xx_v4l2_open
> > 3) [Doc] Fix typos in fs/sysfs/file.c
> > 4) [Doc] Document pci_iomap()
> 
> Hi,
> 
> Please don't make unrelated/random patches look like a patch series.
> 

I tend to have a big panic if sent a pile of patches which have no sequence
numbering.  So if they are all unrelated, please tell me so.

