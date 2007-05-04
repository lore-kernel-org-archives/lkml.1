Return-Path: <linux-kernel-owner+w=401wt.eu-S1161865AbXEDJhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161865AbXEDJhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161868AbXEDJhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:37:40 -0400
Received: from www.osadl.org ([213.239.205.134]:47150 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161865AbXEDJhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:37:40 -0400
From: =?iso-8859-15?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Fri, 4 May 2007 11:37:09 +0200
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <20070503053731.GA17864@kroah.com> <200705030839.13675.hjk@linutronix.de>
In-Reply-To: <200705030839.13675.hjk@linutronix.de>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705041137.09403.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 03 Mai 2007 08:39 schrieb Hans-Jürgen Koch:
> > 
> > Hm, I have about 3 different patches here now, all dependant on each
> > other, yet I can't tell which goes first :(
> > 
> > Can someone just send me 1, or 3 with the correct order in which to
> > apply them?
> > 
> > thanks,
> > 
> > greg k-h
> >
> 
> Hi Greg,
> I attached all the UIO patches I collected so far. This is my series file:
> 
> uio.patch
> fix-early-irq-problem-in-uio.patch
> uio-documentation.patch
> fix-uio_read-type-problem.patch
> uio-dummy.patch
> uio-hilscher-cif-card-driver.patch
> ioremap-in-uio-hilscher-cif.patch
> add-userspace-howto-to-uio-doc.patch
> fix-uio-doc-build-problems.patch
> 
> It should also work without uio-dummy.patch.
> I added Randy's last one-line patch to fix-uio-doc-build-problems.patch.
> 
> All patches are
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> 
> fix-uio-doc-build-problems.patch is also
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 

I also updated the original patch set with all these changes. They can be 
found here:

http://www.osadl.org/projects/downloads/UIO/kernel/

Thanks,
Hans
