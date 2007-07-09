Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbXGIVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbXGIVUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbXGIVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:20:46 -0400
Received: from xenotime.net ([66.160.160.81]:60205 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755061AbXGIVUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:20:46 -0400
Date: Mon, 9 Jul 2007 14:24:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] misc patches
Message-Id: <20070709142417.f3acdfcc.rdunlap@xenotime.net>
In-Reply-To: <200707081754.03824.eike-kernel@sf-tec.de>
References: <200707081754.03824.eike-kernel@sf-tec.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007 17:53:56 +0200 Rolf Eike Beer wrote:

> This are some random patches I've lying around here. They are not related to 
> each other
> 
> 1) Use kcalloc() in drivers/video/aty/atyfb_base.c
> 2) Initialize filp->private_data only once in em28xx_v4l2_open
> 3) [Doc] Fix typos in fs/sysfs/file.c
> 4) [Doc] Document pci_iomap()

Hi,

Please don't make unrelated/random patches look like a patch series.

>From Documentation/SubmittingPatches:

(where a "patch series" is an ordered sequence of multiple,
related patches)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
