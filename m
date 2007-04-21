Return-Path: <linux-kernel-owner+w=401wt.eu-S1031273AbXDUOxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031273AbXDUOxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031271AbXDUOxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:53:10 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50178 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031267AbXDUOxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:53:08 -0400
Date: Sat, 21 Apr 2007 16:33:23 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Fabio Comolli <fabio.comolli@gmail.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Stephen.Clark@seclark.us,
       Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       emisca <emisca.ml@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
In-Reply-To: <b637ec0b0704201257l24d9e9c8ha31221c9c9d8da3e@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704211631540.9989@yvahk01.tjqt.qr>
References: <88SeR-5Sf-15@gated-at.bofh.it>  <20070418140346.636879a1@the-village.bc.nu>
 <46262C0E.9000103@rtr.ca>  <20070418160627.7ab77c30@the-village.bc.nu>
 <46263650.3080705@rtr.ca>  <46263859.2060309@gmail.com> <46265089.4000409@rtr.ca>
  <46265307.7060405@rtr.ca> <4626596E.4040304@seclark.us>  <4627ABE9.8090906@redhat.com>
 <b637ec0b0704201257l24d9e9c8ha31221c9c9d8da3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>On Apr 20 2007 21:57, Fabio Comolli wrote:
>
> hda: TOSHIBA MK8025GAS, ATA DISK drive

MK...? These sort of disks do that stupid pop. Mine -- a MK2003GAH --
does it even while running Linux, if the disk is _idle_.
See http://lkml.org/lkml/2006/11/15/413 - hope it provides some pointers.

Regards,
Jan
-- 
