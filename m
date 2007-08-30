Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXH3Tb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXH3Tb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbXH3TbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:31:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44224 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXH3TbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:31:15 -0400
Date: Thu, 30 Aug 2007 21:31:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rene Herman <rene.herman@gmail.com>
cc: =?ISO-8859-15?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
In-Reply-To: <46D455DB.8000800@gmail.com>
Message-ID: <Pine.LNX.4.64.0708302130210.24730@fbirervta.pbzchgretzou.qr>
References: <200708212149.12912.jopan@alumni.uv.es> <20070822162312.GG9412@csclub.uwaterloo.ca>
 <46CC6A2F.5000406@gmail.com> <200708280044.34475.jopan@alumni.uv.es>
 <46D455DB.8000800@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 19:05, Rene Herman wrote:
>> Okay Rene, I activated SCSI CD-ROM support in kernel config and now all
>> works again. It's strange, because I never used this option to get my DVD
>> device on.
>
> Sheesh. How could anyone _not_ understand you need SCSI CD-ROM support for your
> IDE DVD-RW drive...

Welcome to the wonderful world of SCSIfying ATA. (Don't talk about 
ATAPI, USB/Firewire, it's a different matter.)


	Jan
-- 
