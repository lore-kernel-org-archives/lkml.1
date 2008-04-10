Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYDJMPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYDJMPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYDJMPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:15:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50509 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbYDJMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:14:59 -0400
Message-ID: <47FE04AF.1080103@garzik.org>
Date: Thu, 10 Apr 2008 08:14:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [BUG] linux-next: Tree for April 10 - kernel panic while loading
 ata driver on powermac
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>	<47FDEAFA.10407@linux.vnet.ibm.com>	<47FDEFC8.9070105@garzik.org> <20080410123230.7203f626@core>
In-Reply-To: <20080410123230.7203f626@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 10 Apr 2008 06:45:28 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Kamalesh Babulal wrote:
>>> Hi Stephen,
>>>
>>> The next-20080410 kernel panics while bootup over the PowerMac G5 box, while
>>> loading the ATA driver.
>> IDE driver, you mean.
> 
> Jeff - we may in the kernel world use IDE v ATA to distinguish between
> the two drivers but both are still ATA drives and I don't think its too
> fair to respond this way, especially to someone who has gone to the
> trouble of capturing a very good trace.

Sure.  The main goal was to copy Bart and linux-ide.  That was just an 
aside.

	Jeff



