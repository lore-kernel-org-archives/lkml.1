Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbXFITdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbXFITdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXFITdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:33:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:36824 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168AbXFITdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IRERFxLTSti9pU/RDCgwf7qFP29X4L0GT1dtEkFIzekYMI3Ma+pYjKww3aZDd0c01cZkhExTOf7n8XV5QOGYc7E6surVk6CUWs8HbgzaLsEVjCRa6fe/8izOr6/dSu3yVsNTSEnUKjNZq7uLCZ1GNoPHNPVRJ4QYQJvq2dylt1I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/3] 2.6.22-rc4: known regressions v2
Date: Sat, 9 Jun 2007 21:47:59 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, Robert de Rooy <robert.de.rooy@gmail.com>,
       Gregor Jasny <gjasny@googlemail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mark Lord <mlord@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@redhat.com>,
       Mikael Pettersson <mikpe@it.uu.se>
References: <466ADBE4.5090707@googlemail.com> <466AE609.1030605@googlemail.com>
In-Reply-To: <466AE609.1030605@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706092147.59551.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 June 2007, Michal Piotrowski wrote:

> IDE
> 
> Subject    : libata and legacy ide pcmcia failure
> References : http://lkml.org/lkml/2007/5/17/305
> Submitter  : Robert de Rooy <robert.de.rooy@gmail.com>
> Handled-By : Mark Lord <mlord@pobox.com>
> Status     : problem is being debugged

Not a regression, this device has never worked with Linux.

Bart
