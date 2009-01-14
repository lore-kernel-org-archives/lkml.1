Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbZANJpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbZANJpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZANJpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:45:20 -0500
Received: from www.tglx.de ([62.245.132.106]:40374 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbZANJpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:45:19 -0500
Date: Wed, 14 Jan 2009 10:45:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Roth <mroth@nessie.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Funny problem with 2.6.28: Kernel stalls
In-Reply-To: <4965F5F6.1010801@nessie.de>
Message-ID: <alpine.LFD.2.00.0901141043290.3549@localhost.localdomain>
References: <4953A35C.8090005@nessie.de> <495411FD.60409@gmail.com> <4958B9B7.8060505@nessie.de> <alpine.LFD.2.00.0812291636060.3723@localhost.localdomain> <4965F5F6.1010801@nessie.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On Thu, 8 Jan 2009, Michael Roth wrote:
> Thomas Gleixner schrieb:
> 
> > Can you please provide the following information from the kernel which
> > shows these freeze symptoms:
> > 
> > output of: dmesg
> > output of: cat /proc/timer_list
> 
> It took quite some days but here are the results:

Nothing really obvious. Is the config of the working 2.6.26.7 kernel
the same as the one you used for 2.6.28 ?

Also does adding "nolapic_timer" to the kernel command line solve the
problem ?

Thanks,

	tglx
