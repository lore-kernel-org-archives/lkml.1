Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXFLQTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXFLQTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXFLQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:19:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56204 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbXFLQTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:19:04 -0400
Message-ID: <466EC771.3040509@garzik.org>
Date: Tue, 12 Jun 2007 12:18:57 -0400
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
References: <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org> <20070612141714.GB20408@khazad-dum.debian.net> <20070612153828.GA13888@srcf.ucam.org> <466EBFF0.70100@garzik.org> <20070612155824.GB14044@srcf.ucam.org>
In-Reply-To: <20070612155824.GB14044@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Excluding the corner case of an Expresscard SATA controller (where I 
> suspect you'd want different policy), I doubt there are any cases where 
> you have a laptop with hotplug capabilities without it being implemented 
> as an ACPI bay.

Cardbus card.

	Jeff



