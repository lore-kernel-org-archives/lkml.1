Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZALTql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZALTql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbZALTq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:46:28 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:4386 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbZALTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:46:26 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jon Masters <jcm@redhat.com>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt equivalent
Date: Mon, 12 Jan 2009 12:45:16 -0700
User-Agent: KMail/1.9.10
Cc: Stefan Assmann <sassmann@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <200901121151.53195.bjorn.helgaas@hp.com> <1231788349.4094.21.camel@perihelion.bos.jonmasters.org>
In-Reply-To: <1231788349.4094.21.camel@perihelion.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121245.17479.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009 12:25:49 pm Jon Masters wrote:
> On Mon, 2009-01-12 at 11:51 -0700, Bjorn Helgaas wrote:
> > (I added Eric, Maciej, and Jon because they participated in
> > previous discussion here: http://lkml.org/lkml/2008/6/2/269)
> 
> Thanks. You know what I'd really like even more than being on the CC?
> I'd *love* someone to post a link to documentation on how this actually
> is supposed to work.

I don't work for Intel, so I don't have any internal knowledge.  All
I know is what I read in section 2.15 of the 6700PXH datasheet here:
  http://www.intel.com/Assets/PDF/datasheet/302628.pdf
