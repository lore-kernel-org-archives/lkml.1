Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXC2TCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXC2TCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 15:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXC2TCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 15:02:55 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:9614 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030621AbXC2TCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 15:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tTK3RkMS7oRzBaFSB3TCXBSIvyVLEIbSrWi31J1fnn1Hhbm3QPUVjyC/Urm4uM2012Br6QVAPGK03QJPQYy1hGGuo8srt9LKH4czPUF4/b4bfsp4Xh2rCDjJ+D390s+KacqJNYAvT5ybdS0KLZ2IfFnYOjThSlI6W54vO7loYlU=
Message-ID: <b637ec0b0703291202x472c7c7eq5aa2f4d4646e67af@mail.gmail.com>
Date: Thu, 29 Mar 2007 21:02:52 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [2/5] 2.6.21-rc5: known regressions
Cc: linux-ide@vger.kernel.org, "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <460AC616.3050207@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070327015936.GZ16477@stusta.de> <460AC616.3050207@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

> > This email lists some known regressions in Linus' tree compared to 2.6.20.
> ...
> > Subject    : libata: PATA UDMA/100 configured as UDMA/33
> > References : http://lkml.org/lkml/2007/2/20/294
> >              http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
> >              http://bugzilla.kernel.org/show_bug.cgi?id=8133
> >              http://bugzilla.kernel.org/show_bug.cgi?id=8164
> >              http://lkml.org/lkml/2007/3/21/330
> > Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
> >              Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
> >              Laurent Riffard <laurent.riffard@free.fr>
> >              Lukas Hejtmanek <xhejtman@mail.muni.cz>
> > Handled-By : Tejun Heo <htejun@gmail.com>
> > Patch      : http://thread.gmane.org/gmane.linux.ide/17444
> > Status     : patch available
>

Fixed for me (ata_piix) with today's GIT (Tejun's patch got applied).
Regards,
Fabio
