Return-Path: <linux-kernel-owner+w=401wt.eu-S1767813AbXCJEmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767813AbXCJEmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767815AbXCJEmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:42:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40414 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767813AbXCJEmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:42:10 -0500
Subject: Re: [PATCH] drivers/media/video/se401.c: check kmalloc() return
	value.
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Amit Choudhary <amit2030@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200703090931.01167.oneukum@suse.de>
References: <20070308233049.1c1f850c.amit2030@gmail.com>
	 <200703090931.01167.oneukum@suse.de>
Content-Type: text/plain; charset=utf-8
Date: Sat, 10 Mar 2007 02:42:03 -0200
Message-Id: <1173501723.26213.420.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

Em Sex, 2007-03-09 às 09:31 +0100, Oliver Neukum escreveu:
> Am Freitag, 9. März 2007 08:30 schrieb Amit Choudhary:
> > Description: Check the return value of kmalloc() in function se401_start_stream(), in file drivers/media/video/se401.c.
> 
> Firstly, USB patches to the USB list.

No. In this case, the proper lists for the devices under /drivers/media
is the V4L mailing list (at video4linux-list@redhat.com and
v4l-dvb-maintainer@linuxtv.org), were you will reach the maintainers of
those code (no matter if those devices are USB or not).


Cheers,
Mauro

