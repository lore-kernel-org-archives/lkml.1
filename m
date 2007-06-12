Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbXFLPrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbXFLPrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXFLPri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:47:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55865 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbXFLPrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:47:36 -0400
Message-ID: <466EBFF0.70100@garzik.org>
Date: Tue, 12 Jun 2007 11:46:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@linux.intel.com>,
       =?ISO-8859-1?Q?Dagfinn_Ilmari_Manns=E5ker?= <ilmari@ilmari.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
References: <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org> <20070612141714.GB20408@khazad-dum.debian.net> <20070612153828.GA13888@srcf.ucam.org>
In-Reply-To: <20070612153828.GA13888@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Jun 12, 2007 at 11:17:14AM -0300, Henrique de Moraes Holschuh wrote:
>> On Tue, 12 Jun 2007, Matthew Garrett wrote:
>>> Laptop bays are designed to deal with hotplugging PATA - I don't think 
>>> this is too much of an issue :)
>> The new SATA ones use the SATA hardware hotplug ;-)   Just like the pci-e
>> cards use usb2.0 and pci-e hotplug...
> 
> Yes, but they'll also send an ACPI interrupt even if the SATA host 
> controller doesn't - it's part of the spec for bays.

Regardless, having a laptop does not imply having a docking bay.

	Jeff



