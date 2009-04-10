Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbZDJAsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbZDJAsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZDJArs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:47:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47074 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZDJArr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:47:47 -0400
Message-ID: <49DE9726.40007@garzik.org>
Date: Thu, 09 Apr 2009 20:47:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca> <49DDF744.1090209@garzik.org> <49DE9513.7050607@interlog.com>
In-Reply-To: <49DE9513.7050607@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Gilbert wrote:
> As for the freestanding ata_transport idea which transport
> would a mvsas host adapter belong to which has one phy
> connected to a SATA disk, another connected to a SAS disk and
> a third one connected to a SAS expander with lots of SATA
> disks the other side of that?

Only the direct attach example would use ata_transport.

	Jeff



