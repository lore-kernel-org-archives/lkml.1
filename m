Return-Path: <linux-kernel-owner+w=401wt.eu-S1033237AbXHMSil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033237AbXHMSil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972525AbXHMSPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:15:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56840 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032863AbXHMSPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:15:40 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] [165/2many] MAINTAINERS - DVB
	SUBSYSTEM AND DRIVERS
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1187026197.10249.150.camel@localhost>
References: <46bff9a0.e/9yM2yHeGs6e+wx%joe@perches.com>
	 <1187005362.7067.15.camel@gaivota>  <1187026197.10249.150.camel@localhost>
Content-Type: text/plain; charset=utf-8
Date: Mon, 13 Aug 2007 15:12:06 -0300
Message-Id: <1187028726.664.7.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Seg, 2007-08-13 às 10:29 -0700, Joe Perches escreveu:
> On Mon, 2007-08-13 at 08:42 -0300, Mauro Carvalho Chehab wrote:
> > Em Dom, 2007-08-12 às 23:26 -0700, joe@perches.com escreveu:
> > >  DVB SUBSYSTEM AND DRIVERS
> > > +F:	drivers/media/video/*/*dvb.c
> > > +F:	drivers/media/video/*dvb.c
> > You should remove those patterns.
> > You should also add this entry to DVB:
> > +F: linux/drivers/media/common/saa7146*.c
> 
> DVB SUBSYSTEM AND DRIVERS
> P:	LinuxTV.org Project
> M:	v4l-dvb-maintainer@linuxtv.org
> L:	linux-dvb@linuxtv.org (subscribers-only)
> W:	http://linuxtv.org/
> T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
> S:	Maintained
> F:	drivers/media/dvb/
> F:	drivers/media/common/saa7146*.c
> F:	include/linux/dvb/

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>

Probably, you should also add:

F: Documentation/dvb/

-- 
Cheers,
Mauro

