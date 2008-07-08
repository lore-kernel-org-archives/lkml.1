Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYGHT6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYGHT6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYGHT6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:58:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45673 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946AbYGHT6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:58:40 -0400
Message-ID: <4873C6EB.9080207@garzik.org>
Date: Tue, 08 Jul 2008 15:58:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: [ANNOUNCE]: Target drivers for QLogic Fibre Channel cards released
References: <4873BCD5.5060407@vlnb.net>
In-Reply-To: <4873BCD5.5060407@vlnb.net>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin wrote:
> I'm glad to announce that version 1.0.0 of target drivers for QLogic 
> Fibre Channel cards released and available for download from 
> http://scst.sourceforge.net/downloads.html.
> 
> Two target drivers were released:
> 
>   - Target driver qla2x00t for 22xx and 23xx based QLogic Fibre Channel 
> cards
> 
>   - Target driver qla_isp for 24xx based QLogic Fibre Channel cards
> 
> Those drivers are designed to work in SCST environment. They are high 
> performance drivers, which provide all necessary functionality to work 
> as targets in Fibre Channel environment.
> 
> Detail description of the target drivers you can find on SCST home page 
> http://scst.sourceforge.net.
> 
> Driver qla2x00t is being prepared in form of patch for review and 
> inclusion into the kernel.

Cool.  I'm looking forward to figuring out how to enable ATA target mode 
in a similar manner...  sata_mv and some ahci chips support ATA target mode.

	Jeff



