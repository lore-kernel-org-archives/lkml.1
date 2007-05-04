Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbXEDIGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbXEDIGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965730AbXEDIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:06:44 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50678 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965714AbXEDIGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:06:42 -0400
Date: Fri, 4 May 2007 10:05:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>
cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
In-Reply-To: <d20c3b7d0705032048l8c10d11i98a13881b1c8b3f3@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705040954300.18504@yvahk01.tjqt.qr>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com> 
 <20070503205341.GB943@1wt.eu>  <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
  <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com> 
 <20070503222334.GD943@1wt.eu> <d20c3b7d0705032048l8c10d11i98a13881b1c8b3f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 05:48, Øyvind Vågen Jægtnes wrote:
>
> As a side note, i'm starting to wonder if it was worth the $20k when i
> could just have a linux machine to do the job with a clone for backup
> ;) 

Most often not. The big bosses (which do most decisions yet are not
always the cluefulst wrt. tech) look after "certification", the
"enterprise" sticker, and the correct blame policy (if it breaks, you
can kill <Vendor>; if your linux box breaks, you have to fix it
yourself). And here's an example case that it's not always optimal.

A $2k core router once died of the HD (sounds similar eh?), it took
the vendor 27h to replace it (and their office is just 500m away),
while if could have swapped the faulty disk ourselves, it would have
only taken as long as the disk copy takes (38 minutes for 80 GB at a
transfer rate of 35MB/s).


Jan
-- 
