Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbXERMcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbXERMcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbXERMcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:32:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36314 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754633AbXERMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:32:14 -0400
Date: Fri, 18 May 2007 13:35:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Tejun Heo <htejun@gmail.com>, Dave Jones <davej@redhat.com>,
       Francesco Pretto <ceztko@gmail.com>, Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070518133549.450de880@the-village.bc.nu>
In-Reply-To: <200705180316.45969.rob@landley.net>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
	<20070517033947.GA24757@khazad-dum.debian.net>
	<20070517150420.GA10008@csclub.uwaterloo.ca>
	<200705180316.45969.rob@landley.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 03:16:45 -0400
Rob Landley <rob@landley.net> wrote:

> On Thursday 17 May 2007 11:04 am, Lennart Sorensen wrote:
> > On Thu, May 17, 2007 at 12:39:47AM -0300, Henrique de Moraes Holschuh wrote:
> > > Actually, in my limited experience, SAS is marginally less crappy than 
> SATA,
> > > and has a higher MTBF, probably because the manufacturers try to cut less
> > > corners.  But if one can get high-quality SATA drives (where?!), I don't
> > > know why SAS would be superior to SATA.
> > 
> > SAS is dual ported so you can have redundant cables and controllers.
> 
> Because the controller's far more likely to go than the moving parts...

That only matters if you don't lay the data out with mirrors on different
controllers in the first place - which is cheaper to do with SATA than
buy any SAS kit IMHO
