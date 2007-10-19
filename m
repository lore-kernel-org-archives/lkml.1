Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbXJSMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbXJSMOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXJSMO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:14:29 -0400
Received: from tag.witbe.net ([81.88.96.48]:52021 "EHLO tag.witbe.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbXJSMO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:14:28 -0400
Date: Fri, 19 Oct 2007 14:14:21 +0200
From: Paul Rolland <rol@as2917.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by
 libata
Message-ID: <20071019141421.5a13e90c@tux.DEF.witbe.net>
In-Reply-To: <47182323.10706@gmail.com>
References: <20070826203513.4fa35f68@tux.DEF.witbe.net>
	<6bffcb0e0708261637s3369dd6fl1f833461e41c4daa@mail.gmail.com>
	<47182323.10706@gmail.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Fri, 19 Oct 2007 12:23:15 +0900
Tejun Heo <htejun@gmail.com> wrote:

> > On 26/08/07, Paul Rolland <rol@as2917.net> wrote:
> >> My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
> >> reporting a :
> >> irq 23: nobody cared (try booting with the "irqpoll" option)
> >> together with a Call Trace, but :
> >>  - irqpoll is present on the command line,
> >>  - the irq is reported to be used by libata,
> >>  - the irqpoll option is mandatory if I want _some_ of my SATA disks to
> >> be accessible.
> 
> Does this still happen with 2.6.23?  If so, please post boot log.  Thanks.
> 
Not tested yet, will do so during the WE.

Regards,
Paul
