Return-Path: <linux-kernel-owner+w=401wt.eu-S1765059AbXHMRek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765059AbXHMRek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032604AbXHMRbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:31:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3252 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032526AbXHMRbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:31:13 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] [165/2many] MAINTAINERS - DVB
	SUBSYSTEM AND DRIVERS
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1187005362.7067.15.camel@gaivota>
References: <46bff9a0.e/9yM2yHeGs6e+wx%joe@perches.com>
	 <1187005362.7067.15.camel@gaivota>
Content-Type: text/plain; charset=utf-8
Date: Mon, 13 Aug 2007 10:29:57 -0700
Message-Id: <1187026197.10249.150.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 08:42 -0300, Mauro Carvalho Chehab wrote:
> Em Dom, 2007-08-12 às 23:26 -0700, joe@perches.com escreveu:
> >  DVB SUBSYSTEM AND DRIVERS
> > +F:	drivers/media/video/*/*dvb.c
> > +F:	drivers/media/video/*dvb.c
> You should remove those patterns.
> You should also add this entry to DVB:
> +F: linux/drivers/media/common/saa7146*.c

DVB SUBSYSTEM AND DRIVERS
P:	LinuxTV.org Project
M:	v4l-dvb-maintainer@linuxtv.org
L:	linux-dvb@linuxtv.org (subscribers-only)
W:	http://linuxtv.org/
T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
S:	Maintained
F:	drivers/media/dvb/
F:	drivers/media/common/saa7146*.c
F:	include/linux/dvb/



