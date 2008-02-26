Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbYBZW0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbYBZW0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764955AbYBZWXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:27320 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764386AbYBZWXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SXpzoCMXN/fprkc/z5F5x93WD6ZhPBT3+nEJtsSpuqOQeUvVOqLLw7oTD6+PT2xNY1QGvhLNSem0vRzA7v4CPh0mVKniX1tJjYsOZ8jTSFDL5Ly6OZanSPMpJfiq4Eu9QluZPbTuN2qZSXVhbGRdUYdj6VZ5W+brKU5ZvCLbYqo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH 0/6] IDE: new series of Coding Style Fixes
Date: Tue, 26 Feb 2008 22:01:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
References: <20080223183812.5af6d36d@paolo-desktop> <200802241738.57839.bzolnier@gmail.com> <4d8e3fd30802241012k3794882fm7f35a86b9481016f@mail.gmail.com>
In-Reply-To: <4d8e3fd30802241012k3794882fm7f35a86b9481016f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262201.39770.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008, Paolo Ciarrocchi wrote:

[...]

> >  >  drivers/ide/ide-floppy.c     |    4 +-
> >  >  drivers/ide/legacy/ali14xx.c |   11 +++--
> >  >  drivers/ide/legacy/hd.c      |   79 ++++++++++++++++++------------------
> >  >  drivers/ide/pci/cmd640.c     |   90 +++++++++++++++++++++---------------------
> >  >  drivers/ide/pci/it8213.c     |    9 ++--
> >  >  drivers/ide/pci/opti621.c    |   50 ++++++++++++------------
> >  >  6 files changed, 122 insertions(+), 121 deletions(-)
> >
> >  I applied all the rest (some with minor fixes).
> 
> Good. Where can I look to see the end result of our work?

the "usual" place:

http://www.kernel.org/pub/linux/kernel/people/bart/pata-2.6/

[ or "tomorrow's" linux-next ]

Thanks,
Bart
