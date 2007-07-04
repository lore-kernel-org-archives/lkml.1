Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbXGDITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbXGDITe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbXGDITW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:19:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40603 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbXGDITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:19:20 -0400
Message-ID: <468B57F9.1040804@tw.ibm.com>
Date: Wed, 04 Jul 2007 16:19:05 +0800
From: Albert Lee <albertcc@tw.ibm.com>
Reply-To: albertl@mail.com
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [info] What's in Jeff's libata-dev inbox?
References: <20070702151639.GA10948@havoc.gtf.org> <20070702165327.2646a761@the-village.bc.nu> <46892AEF.8@garzik.org>
In-Reply-To: <46892AEF.8@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>> I have patches from Alan (pata_sis FIFO whack, pata_dma option), Tejun,
>>> Albert and Kristen still to be reviewed.  Will get to those on Friday,
>>> after the July 4th US holiday.tions(-)
> 
> 
> Just to be more specific, my to-review inbox contains:
> 
> Alan: pata_sis FIFO whack, pata_dma option
> 
> Tejun: PMP patchbomb
> 
> Albert: irq_on/off restructure, irq-driven PIO to wq, minor PIO fixes
> 

Please ignore the "irq-driven PIO to wq" patchset; it's not ready.
For the other two patchsets, I'll rediff and resend for your review.

--
albert


