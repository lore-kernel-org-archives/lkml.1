Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZFSQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZFSQgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZFSQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:36:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:29331 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZFSQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:36:11 -0400
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for post-2.6.30
Date: Fri, 19 Jun 2009 18:36:05 +0200
User-Agent: KMail/1.9.9
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <20090526220517.25381.75976.stgit@localhost.localdomain> <20090618054845.GC8482@atomide.com> <20090619162342.GP24573@n2100.arm.linux.org.uk>
In-Reply-To: <20090619162342.GP24573@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191836.07462.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, Russell, Tony,

On Friday 19 June 2009 18:23:42 Russell King - ARM Linux wrote:
> On Thu, Jun 18, 2009 at 08:48:47AM +0300, Tony Lindgren wrote:
> > Paul, can you please post a git pull request for Russell on these?
> > I think these should still go in if possible.
> >
> > Russell, if you think it's too late, I'll pile them up into omap
> > for-next branch.
>
> Let's merge them.
Also, can you look at '[PATCH 0/2] Allows the SDRAM self refresh to work with 
2 chip selects' which apply on top of Paul's SDRC patches?

Regards,
Jean

>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php


