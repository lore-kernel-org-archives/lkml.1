Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbXH3UMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbXH3UMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXH3ULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:11:48 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49456 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXH3ULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:11:48 -0400
Message-ID: <46D7231B.3080807@gmail.com>
Date: Thu, 30 Aug 2007 22:05:47 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: =?ISO-8859-15?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
References: <200708212149.12912.jopan@alumni.uv.es> <20070822162312.GG9412@csclub.uwaterloo.ca> <46CC6A2F.5000406@gmail.com> <200708280044.34475.jopan@alumni.uv.es> <46D455DB.8000800@gmail.com> <Pine.LNX.4.64.0708302130210.24730@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708302130210.24730@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2007 09:31 PM, Jan Engelhardt wrote:

> On Aug 28 2007 19:05, Rene Herman wrote:

>> Sheesh. How could anyone _not_ understand you need SCSI CD-ROM support
>> for your IDE DVD-RW drive...
> 
> Welcome to the wonderful world of SCSIfying ATA. (Don't talk about ATAPI,
> USB/Firewire, it's a different matter.)

Well -- the world where ATA, SCSI, USB, Firewire and what have you are 
low-level drivers to a unifying storage layer is under non too obscure 
definitions sort of not non-wonderful...

Admittedly, the unifying layer is a little SCSI inspired but so is a lot of 
the hardware. As long as the users (the humans) resist SCSI inspiration, it 
should be safe.

Rene
