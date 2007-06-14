Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbXFNOdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbXFNOdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXFNOdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:33:07 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:38806
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbXFNOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:33:06 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070614112329.3645c397@the-village.bc.nu>
	<20070614103846.GA7902@elte.hu>
	<200706141328.00798.bernd.paysan@gmx.de>
	<20070614132457.GB29423@elte.hu>
From: Michael Poole <mdpoole@troilus.org>
Date: Thu, 14 Jun 2007 10:33:04 -0400
In-Reply-To: <20070614132457.GB29423@elte.hu> (Ingo Molnar's message of "Thu\, 14 Jun 2007 15\:24\:57 +0200")
Message-ID: <87bqfi38tb.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> this is largely irrelevant to my argument: the FSF is clearly trying to 
> extend the scope of the GPL to restrict the distribution of certain 
> hardware+software combinations. The FSF is not really arguing that the 
> boundary between software and hardware is diffuse. (which btw. it 
> clearly is) The FSF simply wants to be able to say via the GPLv3: "to be 
> able to distribute GPL-ed software, the hardware is required to do this 
> and this".

Most people arguing for the expansive interpretation do not really
care what hardware is combined with what software.  They care about
the ability for the user (in the GPLv2's terms, someone who receives
GPL'ed software) to have comparable ability to modify and
(re-)distribute the software as the software distributor does.  The
issue of GPLed software on DRMed hardware applies equally to digital
video recorders, where the hardware and software distributor are
usually the same, and video game consoles, where they are not.

There is no good reason to treat a "GPL-incompatible" hardware
platform (for example, incompatible due to restrictions on the keys to
generate digital signatures) differently than a "GPL-incompatible"
patent area.  If a software distributor cannot simultaneously comply
with the GPL and his other obligations, he should either not
distribute the software or be prepared to face the liability from
breaching his obligations.

Michael Poole
