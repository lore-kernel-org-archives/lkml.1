Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbXGCW1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbXGCW1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbXGCW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:27:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62505 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbXGCW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=YEpNwF1XZBpq42BwIrZv1imRO02Kxa1z7uFUI523E6fN02OxQkInY/4S3op4QJCAfuXdZ5PwWzzLc7K3GWmGHH1FmY3r+C1vH3TCm6hgJ6I7/tbJ5DWx6+7Xob3uwFVtz8/7JwcejtPz7bxIsBodIyaZsPKcnpQuE4s2X2TTYIk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] pata_hpt3x3: Major reworking and testing
Date: Wed, 4 Jul 2007 00:44:27 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jeff@garzik.org
References: <20070703161002.1576c39d@the-village.bc.nu> <200707032212.01619.bzolnier@gmail.com> <468AB462.4090203@ru.mvista.com>
In-Reply-To: <468AB462.4090203@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707040044.27185.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > http://www.linuxhq.com/kernel/v2.3/10/drivers/block/hpt343.c
> 
> > Does anybody have DOS driver for HPT343?  Google doesn't have it...
> 
>     I have the drivers for HPT34[35] -- tried dissassembling them some years 
> ago...

/me wants

Bart
