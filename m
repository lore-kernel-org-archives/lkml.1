Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbXHNNf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbXHNNf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXHNNfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:35:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:51156 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXHNNfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kb7K56RnkC5dQoOVofgRDhvdlvERNwcYcGD7XW/UTmXGN70MVx1sInV+qSFkJQNONpRtpLm4MDKysIPM4LJjQ+hIV5YwGoCzQAqSs3eJaCY/oSwb//ZtYa9qkRtqKJ4WOtAo1inQbrkfRMgXEFMslOiwYvyZzRalg1cncrK9KXQ=
Message-ID: <1a297b360708140635h3f7d00e5sa8c98a84340b8ff5@mail.gmail.com>
Date: Tue, 14 Aug 2007 17:35:46 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS - VIDEO FOR LINUX
Cc: "Joe Perches" <joe@perches.com>, "Michael Krufky" <mkrufky@linuxtv.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <1187098031.7287.10.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
	 <1187028910.664.11.camel@gaivota>
	 <1187030038.10249.237.camel@localhost>
	 <1a297b360708131222t55be6fbax78a6659762a98e7e@mail.gmail.com>
	 <1187056816.10249.366.camel@localhost> <46C10E85.2070902@linuxtv.org>
	 <1187059484.10249.370.camel@localhost>
	 <1187098031.7287.10.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>
> Em Seg, 2007-08-13 às 19:44 -0700, Joe Perches escreveu:
> > On Mon, 2007-08-13 at 22:08 -0400, Michael Krufky wrote:
> > > drivers/media/video  -- v4l
> > > drivers/media/radio  -- v4l
> > >
> > > drivers/media/dvb   -- dvb
> >
> > VIDEO FOR LINUX
> > P:    Mauro Carvalho Chehab
> > M:    mchehab@infradead.org
> > P:    LinuxTV.org Project
> > M:    v4l-dvb-maintainer@linuxtv.org
> > L:    video4linux-list@redhat.com
> > W:    http://linuxtv.org
> > T:    git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
> > S:    Maintained
> > F:    Documentation/video4linux/
> > F:    drivers/media/video/
> > F:    drivers/media/radio/
> > F:    include/linux/video_decoder.h
> > F     include/linux/videodev.h
> You missed ':'
> > F:    include/linux/videodev2.h
> > F:    include/media/
>
> This is not ok. Some maintained files won't be hit. You should add also
> something like:


> F: drivers/media/*


This is NOT OK !
