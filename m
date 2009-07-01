Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZGABUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZGABUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762790AbZGAApW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:45:22 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:57677 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762312AbZGAApV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:45:21 -0400
Date: Wed, 1 Jul 2009 01:50:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Greg KH <gregkh@suse.de>
cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Kurt Garloff <garloff@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
In-Reply-To: <20090630223040.GA3802@suse.de>
Message-ID: <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org> <20090630223040.GA3802@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Greg KH wrote:

> >  These days an IOCK NMI typically happens in response to a PCI SERR -- it 
> > may be useful to traverse PCI buses to find the offender and dump this 
> > information on this occasion too.  The south bridge may have additional 
> > status too.
> 
> Sure, that would be great to have.  Care to make a patch?  :)

 ENOTIME, sorry.  Next year perhaps.  Or a homework project for one of the 
newbies. ;)

  Maciej
