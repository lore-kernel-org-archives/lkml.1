Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbXHNN1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbXHNN1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXHNN1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:27:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41575 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXHNN1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:27:30 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS -	VIDEO
	FOR LINUX
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
       Manu Abraham <abraham.manu@gmail.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <1187059484.10249.370.camel@localhost>
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
	 <1187028910.664.11.camel@gaivota>	<1187030038.10249.237.camel@localhost>
	 <1a297b360708131222t55be6fbax78a6659762a98e7e@mail.gmail.com>
	 <1187056816.10249.366.camel@localhost>  <46C10E85.2070902@linuxtv.org>
	 <1187059484.10249.370.camel@localhost>
Content-Type: text/plain; charset=utf-8
Date: Tue, 14 Aug 2007 10:27:11 -0300
Message-Id: <1187098031.7287.10.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Seg, 2007-08-13 às 19:44 -0700, Joe Perches escreveu:
> On Mon, 2007-08-13 at 22:08 -0400, Michael Krufky wrote:
> > drivers/media/video  -- v4l
> > drivers/media/radio  -- v4l
> > 
> > drivers/media/dvb   -- dvb
> 
> VIDEO FOR LINUX
> P:	Mauro Carvalho Chehab
> M:	mchehab@infradead.org
> P:	LinuxTV.org Project
> M:	v4l-dvb-maintainer@linuxtv.org
> L:	video4linux-list@redhat.com
> W:	http://linuxtv.org
> T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
> S:	Maintained
> F:	Documentation/video4linux/
> F:	drivers/media/video/
> F:	drivers/media/radio/
> F:	include/linux/video_decoder.h
> F	include/linux/videodev.h
You missed ':'
> F:	include/linux/videodev2.h
> F:	include/media/

This is not ok. Some maintained files won't be hit. You should add also
something like:
F: drivers/media/*
F: drivers/media/common/ir-functions.c
F: drivers/media/common/ir-keymaps.c
F: drivers/media/common/Kconfig
F: drivers/media/common/Makefile
	
-- 
Cheers,
Mauro

