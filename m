Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbXF2Rzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbXF2Rzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764812AbXF2Rzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:55:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:16321 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbXF2Rzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DgdtIazewomdeHalwKtlZOWxxow4VtwXiaTIx+3vSLrqO8gCWAX38ntE7oKLv1rkZmPqhiNjrAmfh9+Ozx3D0PXEwrSbJhrRUXXLSGVZgeObcF7xrpaNsD9/plgfSYnbIwaqIeNFCgtaDz0y0lMuk76l9VClRnTcRRV4n4294hc=
Message-ID: <6bffcb0e0706291055p13abc260j98124c05b53560ac@mail.gmail.com>
Date: Fri, 29 Jun 2007 19:55:35 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [1/2] 2.6.22-rc6: known regressions v2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Rodrigo Luiz" <troops.of.doom@gmail.com>, alsa-devel@alsa-project.org,
       "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@suse.cz>,
       "Ben Collins" <bcollins@ubuntu.com>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       "David Chinner" <dgc@sgi.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Tejun Heo" <htejun@gmail.com>,
       "Rodney Gordon II" <meff@spherevision.org>
In-Reply-To: <20070629175920.6af0c62b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46852187.3080504@googlemail.com>
	 <20070629175920.6af0c62b@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > SATA/PATA
> >
> > Subject    : libata IT821X driver still fails! Hard-freezes system
> > References : http://lkml.org/lkml/2007/6/14/82
> > Submitter  : Rodney Gordon II <meff@spherevision.org>
> > Status     : unknown
>
> Not a regression as it seems this user's box has always been broken.

I removed this bug from the kr list.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
