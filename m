Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbXLLVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbXLLVTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXLLVTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:19:44 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:60708 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXLLVTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:19:43 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 16:19:43 EST
Date: Wed, 12 Dec 2007 13:13:03 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Adrian Bunk <bunk@kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] drivers/media/Makefile: always
 enter video/
In-Reply-To: <20071212184032.GE10069@stusta.de>
Message-ID: <Pine.LNX.4.58.0712121310330.111@shell2.speakeasy.net>
References: <200712120934.46156.toralf.foerster@gmx.de> <475FE553.4020702@linuxtv.org>
 <1197470781.4744.41.camel@gaivota> <20071212184032.GE10069@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007, Adrian Bunk wrote:
> >
> > I don't see any issue on making both dependent on VIDEO_TUNER for
> > 2.6.24, since they are currently used only by tuner core module
> > (tuner.ko).
> >...
>
> If "selected code isn't included" also counts as a bug at least dabusb
> is also affected by the same bug.

> What about the patch below instead that fixes the actual bug instead of
> working around it?

Pretty much exactly the same as the patch I posted on Oct 19th.  Some
people like to make things harder than they need to be.

http://article.gmane.org/gmane.comp.video.video4linux/35274

