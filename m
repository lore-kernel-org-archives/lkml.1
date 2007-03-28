Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXC1TyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXC1TyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965731AbXC1TyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:54:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:47559 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965736AbXC1TyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:54:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add machine_ops interface  to abstract halting and rebooting
Date: Wed, 28 Mar 2007 21:54:04 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
References: <46099709.2000304@goop.org> <200703282143.53037.ak@suse.de> <460AC665.2090705@goop.org>
In-Reply-To: <460AC665.2090705@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282154.04245.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 21:47, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > On Wednesday 28 March 2007 21:32, Jeremy Fitzhardinge wrote:
> >   
> >> machine_ops is an interface for the machine_* functions defined in
> >> <linux/reboot.h>.  This is intended to allow hypervisors to intercept
> >> the reboot process, but it could be used to implement other x86
> >> subarchtecture reboots.
> >>     
> >
> > Both patches added thanks
> >   
> 
> I presume you've also got the reboot-fixups cleanup patch?

No, please resend too

-Andi
