Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZCXW6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZCXW6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZCXW6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:58:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53082 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZCXW6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:58:22 -0400
Date: Tue, 24 Mar 2009 22:58:12 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrey Panin <pazke@donpac.ru>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, torvalds@linux-foundation.org,
       williams@redhat.com
Subject: Re: [PATCH 01/30] disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE
Message-ID: <20090324225812.GA30827@srcf.ucam.org>
References: <20090324151034.GC6859@ports.donpac.ru> <20090324152203.6a989d06@lxorguk.ukuu.org.uk> <20090324205945.GA28394@srcf.ucam.org> <20090324212653.77d6e70c@lxorguk.ukuu.org.uk> <20090324213416.GA29507@srcf.ucam.org> <20090324213841.59d6b299@lxorguk.ukuu.org.uk> <20090324214321.GA29671@srcf.ucam.org> <20090324221816.50e7ccc2@lxorguk.ukuu.org.uk> <20090324222934.GA30503@srcf.ucam.org> <20090324223632.66680ebd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324223632.66680ebd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:36:32PM +0000, Alan Cox wrote:
> On Tue, 24 Mar 2009 22:29:34 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > I'd prefer not to go with this approach unless we've got a convincing 
> > number of bugs filed. It's guaranteed to reduce hardware support in 
> > favour of fixing an unknown number of machines.
> 
> I get a regular stream of complaints. But as I said Red Hat is the patch
> originator, Red Hat has the distro bugzilla so perhaps Red Hat folks can
> comment ?

I've had a dig through Bugzilla but couldn't find it, and it doesn't 
seem to be in anything we're shipping right now. Clark, do you have a 
pointer to a bug that this patch came from?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
