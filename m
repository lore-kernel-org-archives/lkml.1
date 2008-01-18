Return-Path: <linux-kernel-owner+w=401wt.eu-S1764834AbYARVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764834AbYARVb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbYARVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:31:52 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48072 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128AbYARVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:31:51 -0500
Date: Fri, 18 Jan 2008 13:46:24 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/2] x86: MMCONF enable MCFG early
In-reply-to: <20080118100141.GA3654@elte.hu>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>,
       Robert Hancock <hancockr@shaw.ca>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Len Brown <lenb@kernel.org>
Message-id: <200801181346.25639.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801161405.17889.yinghai.lu@sun.com>
 <20080118100044.GC30637@elte.hu> <20080118100141.GA3654@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 02:01:41 am Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Ingo,
> > > it seems you removed
> > > > patch
> > > > 	x86: validate against ACPI motherboard resources
> > > last night. 
> > > 
> > > was it dropped?
> > 
> > yeah, i bounced it over to Greg - but Greg has not indicated it yet 
> > whether he has picked it up. Andrew has it in -rc8-mm1 at the moment.
> 
> so these two patches of yours:
> 
>  Subject: [PATCH 1/2] x86: clear pci_mmcfg_virt when mmcfg get rejected
>  Subject: [PATCH 2/2] x86: MMCONF enable MCFG early
> 
> should probably go to Andrew/Greg as well.

Andrew,

can you pick them up? or need me to resend that to you again.

Thanks

YH
