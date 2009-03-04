Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZCDJHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZCDJHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZCDJGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:06:43 -0500
Received: from www.tglx.de ([62.245.132.106]:48397 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZCDJGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:06:41 -0500
Date: Wed, 4 Mar 2009 10:06:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Large amount of scsi-sgpool objects
In-Reply-To: <49AE32B5.9040603@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.2.00.0903041004300.29264@localhost.localdomain>
References: <49ACF8FE.2020904@panasas.com>  <1236093718.3263.3.camel@localhost.localdomain>  <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>  <1236097526.3263.17.camel@localhost.localdomain>  <20090303192212.GA20705@elte.hu> 
 <1236115544.15993.22.camel@localhost.localdomain>  <20090303214454.GA8288@elte.hu>  <1236119990.24019.35.camel@localhost.localdomain>  <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>  <20090303234834.GA13389@elte.hu> 
 <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

On Wed, 4 Mar 2009, Stefan Richter wrote:
> As I said, I recommend that people do not receive those off-topic
> patches by default, only on demand.  (Because I sometimes work with -rt
> users.)

And as I said before, I missed to remove the patch before pushing out
the -rt tree. So I really do not need repeated advise on how to do my
work.

Thanks,

	tglx
