Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbXHVPxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbXHVPxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXHVPxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:53:47 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36943 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbXHVPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:53:46 -0400
Message-ID: <46CC5AE4.1090600@gmail.com>
Date: Wed, 22 Aug 2007 17:48:52 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-15?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
References: <200708212149.12912.jopan@alumni.uv.es>	<46CB626F.8020801@gmail.com>	<200708220339.45138.jopan@alumni.uv.es>	<46CBA0F0.70503@gmail.com> <20070822122359.7ce8ddaa@the-village.bc.nu>
In-Reply-To: <20070822122359.7ce8ddaa@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2007 01:23 PM, Alan Cox wrote:

>> The old SATA driver available from the IDE menu also does not support your 
>> chip, so I don't believe there are any workarounds -- you'll need the issue 
>> fixed.
> 
> What issue ?
> 
> From the report its quite simple - enable the correct CONFIG_ATA based
> drivers and it should all work fine.

He has a SATA harddrive and an IDE DVD drive. When he compiles with 
CONFIG_ATA_PIIX (a driver which advertises both SATA and PATA in its 
description) his drive works, his DVD does not. Is that not the correct 
driver? Does he need something else? How does he get his DVD to work?

Rene.

