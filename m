Return-Path: <linux-kernel-owner+w=401wt.eu-S937852AbXG0Uhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937852AbXG0Uhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934911AbXG0UhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:37:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934819AbXG0UhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:37:13 -0400
Date: Fri, 27 Jul 2007 13:35:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       Adam Belay <ambx1@neo.rr.com>, Len Brown <lenb@kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, serial: always probe for legacy COM ports
Message-Id: <20070727133528.bfebb869.akpm@linux-foundation.org>
In-Reply-To: <200707271426.30962.bjorn.helgaas@hp.com>
References: <200707271158.50028.bjorn.helgaas@hp.com>
	<200707271411.42253.bjorn.helgaas@hp.com>
	<46AA53E3.5080501@garzik.org>
	<200707271426.30962.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 14:26:30 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Friday 27 July 2007 02:21:55 pm Jeff Garzik wrote:
> > Bjorn Helgaas wrote:
> > > On Friday 27 July 2007 12:05:51 pm Jeff Garzik wrote:
> > >> This is still incomplete, as repeatedly stated.  Here is the email, again.
> > 
> > > OK, uncle!  I'll work on your helpful advice (thanks for that), but
> > > it feels too risky for this stage of 2.6.23.  Maybe I can come up with
> > > something for a future release.
> > 
> > The changeset in the kernel is too risky _without_ the changes I described.
> 
> That's what I meant.  Andrew already has a revert patch in -mm, and
> the safest path seems like putting the reversion in 2.6.23 and working
> on your advice post-2.6.23.
> 

ok, thanks, I'll pull that trigger.
