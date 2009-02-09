Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZBIQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZBIQak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZBIQa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:30:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:37969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZBIQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:30:27 -0500
Date: Mon, 9 Feb 2009 08:30:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, stable@kernel.org
Subject: Re: patch acpi-remove-locking-from-pm1x_sts-register-reads.patch
 added to 2.6.28-stable tree
Message-ID: <20090209083050.361e997d@infradead.org>
In-Reply-To: <20090209162402.GA13931@suse.de>
References: <20090208211932.4CAB349019@coco.kroah.org>
	<200902090124.44228.s.L-H@gmx.de>
	<20090209162402.GA13931@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 08:24:02 -0800
Greg KH <gregkh@suse.de> wrote:

> On Mon, Feb 09, 2009 at 01:24:43AM +0100, Stefan Lippers-Hollmann
> wrote:
> > Hi
> > 
> > On Sonntag, 8. Februar 2009, gregkh@suse.de wrote:
> > > 
> > > This is a note to let you know that we have just queued up the
> > > patch titled
> > > 
> > >     Subject: ACPI: remove locking from PM1x_STS register reads


why is this -stable material?
this is a performance improvement....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
