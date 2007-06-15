Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXFOPOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXFOPOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXFOPOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:14:06 -0400
Received: from saeurebad.de ([85.214.36.134]:48600 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbXFOPOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:14:05 -0400
Date: Fri, 15 Jun 2007 17:13:30 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Jinxed VAIO wreckage - current state of affairs
Message-ID: <20070615151330.GA27908@saeurebad.de>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1181418873.4404.402.camel@chaos> <200706092259.50694.rjw@sisk.pl> <20070609200827.635fec79.akpm@linux-foundation.org> <1181909157.8176.342.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181909157.8176.342.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, Jun 15, 2007 at 02:05:57PM +0200, Thomas Gleixner wrote:
> Just found a brown paperbag bug in the resume patch logic. Sigh, I was
> staring at that code for month without noticing.
> 
> Andrew,
> 
> can you please test
> 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt9.patch

404
