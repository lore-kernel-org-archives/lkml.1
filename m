Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYGaUhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYGaUhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGaUho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:37:44 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:53716 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYGaUhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:37:43 -0400
Date: Thu, 31 Jul 2008 15:37:39 -0500
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: libata badness
Message-ID: <20080731203739.GA17718@ld0162-tx32.am.freescale.net>
References: <95646AC3-5385-4F59-8EBA-20F811168A87@kernel.crashing.org> <20080731190259.GJ26938@trinity.fluff.org> <836C281D-4D3A-4547-98D9-143A690698AF@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <836C281D-4D3A-4547-98D9-143A690698AF@kernel.crashing.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 03:24:31PM -0500, Kumar Gala wrote:
> >it would be helpful to compile a kernel with verbose fault information
> >turned on.
> 
> Doesn't seem to provide too much more info on ppc.

I'm pretty sure it does the same thing on ppc as on all the other
architectures.

> just says the file/ line number of the badness.

...which is a lot more useful than an address in someone else's kernel
image.

-Scott
