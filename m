Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbXGDQRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbXGDQRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXGDQRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:17:39 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22316 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbXGDQRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:17:37 -0400
Message-ID: <468BC81F.7090102@msgid.tls.msk.ru>
Date: Wed, 04 Jul 2007 20:17:35 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Dan Aloni <da-x@monatomic.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
References: <468392CE.6010206@msgid.tls.msk.ru> <20070704154405.GA27166@localdomain>
In-Reply-To: <20070704154405.GA27166@localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Aloni wrote:
> On Thu, Jun 28, 2007 at 02:51:58PM +0400, Michael Tokarev wrote:
>> [..]
>> Test machine was using MPTSAS driver for the following card:
>>   SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)
>>
>> Pretty similar results were obtained on an AHCI controller:
>>   SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01)
>> on another machines.
> 
> Are you sure that NCQ was enabled between the controller and drive? 
> Did you verify this? I know about some versions that disable NCQ 
> support internally in their firmware (something to do with bugs in
> error handling).

The next obvious question is: how to check/verify this?

/mjt
