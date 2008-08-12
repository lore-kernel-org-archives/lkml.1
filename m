Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYHLLhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYHLLhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYHLLhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:37:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:37074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYHLLhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:37:10 -0400
Date: Tue, 12 Aug 2008 04:37:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [patch 2/2] fastboot: use a DMI match table to set defaults for
 port-disable
Message-ID: <20080812043718.038d3e56@infradead.org>
In-Reply-To: <20080812091009.05a32b39@lxorguk.ukuu.org.uk>
References: <20080811153542.61095e5c@infradead.org>
	<20080811153730.74599410@infradead.org>
	<1218503351.25524.28.camel@californication>
	<20080811220440.5cc1bc2d@infradead.org>
	<20080812091009.05a32b39@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 09:10:09 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > if you solder the board... well you can add a tiny kernel patch or
> > change the dmi ;)
> 
> Lots of people have them modified and you can even buy them
> pre-modded as an end user. It needs to be simpler than hacking your
> kernel. In fact this argues that the port disables should be handled
> by user space not by the kernel ?

which is a commandline option then; because once userspace runs you've
already paid the price in terms of boottime otherwise and would make
the idea entirely moot.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
