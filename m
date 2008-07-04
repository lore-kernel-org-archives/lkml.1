Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYGDVTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYGDVTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYGDVTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:19:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYGDVTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:19:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Fri, 4 Jul 2008 23:21:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <200807012158.34356.rjw@sisk.pl> <20080701202453.GD4896@elte.hu>
In-Reply-To: <20080701202453.GD4896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807042321.32660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday, 1 of July 2008, Ingo Molnar wrote:
> > > 
> > > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > 
> > > > Assuming it works for Rafael (still haven't had time to pull my nx6125 
> > > > out of storage):
> > > > 
> > > > Signed-off-by: mjg@redhat.com
> > > 
> > > Rafael, could you please try the latest tip/master that i've just pushed 
> > > out:
> > > 
> > >   http://people.redhat.com/mingo/tip.git/README
> > > 
> > > it has the final form of these changes integrated - it should in 
> > > theory work out of box on your system, with no boot parameters or 
> > > other explicit quirks needed anywhere.
> > 
> > I tested patches [1/2] (your version) and [2/2] on top of today's 
> > linux-next and they work just fine.
> 
> thanks Rafael!

Can you please push them to linux-next, btw?

They still apply cleanly to linux-next for me.

Thanks,
Rafael
