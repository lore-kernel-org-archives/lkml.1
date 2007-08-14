Return-Path: <linux-kernel-owner+w=401wt.eu-S935385AbXHNEd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935385AbXHNEd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXHNEdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:33:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4094 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbXHNEdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:33:00 -0400
Subject: Re: [PATCH] [463/2many] MAINTAINERS - STRADIS MPEG-2 DECODER DRIVER
From: Joe Perches <joe@perches.com>
To: Nathan Laredo <laredo@gnu.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <246a89290708132104h4145349ah4a4a56ef852a1bb3@mail.gmail.com>
References: <46bffc01.7c95Dz5xUUkjysHI%joe@perches.com>
	 <246a89290708132104h4145349ah4a4a56ef852a1bb3@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 21:32:47 -0700
Message-Id: <1187065967.32555.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 21:04 -0700, Nathan Laredo wrote:
> Well, technically speaking, there are multiple files to the stradis
> driver, not just stradis.c.

These files seem to be shared between drivers.

the Kconfig file shows:

obj-$(CONFIG_VIDEO_STRADIS) += stradis.o

as the only STRADIS file.

Are you the maintainer for other entries?
Should I add these entries?

drivers/media/video/cs8420.h
drivers/media/video/ibmmpeg2.h
drivers/media/video/saa5249.c
drivers/media/video/saa7110.c
drivers/media/video/saa7111.c
drivers/media/video/saa7121.h
drivers/media/video/saa7146*.h
drivers/media/video/saa7185.h
drivers/media/video/saa7196.h
drivers/media/video/videodev.c



