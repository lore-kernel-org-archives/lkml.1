Return-Path: <linux-kernel-owner+w=401wt.eu-S1030666AbXFHO2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666AbXFHO2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXFHO21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:28:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57252 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030646AbXFHO2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:28:23 -0400
Date: Fri, 8 Jun 2007 10:28:22 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070608142822.GB25649@havoc.gtf.org>
References: <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com> <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com> <4667B347.9040900@gmail.com> <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org> <20070607224746.GA23290@havoc.gtf.org> <46690D10.9040808@gmail.com> <20070608122750.7f8ae0e0@the-village.bc.nu> <46693E33.6080705@gmail.com> <20070608124058.7948dee1@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608124058.7948dee1@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:40:58PM +0100, Alan Cox wrote:
> Seems best to me - we know the current code breaks a load of systems and
> the change should not break anything but fix them all. If we ship without
> it being changed then a load of people are stuck with broken ATA.

So you have verified that Tejun's experimental change "fixes them all"?

Proof?  Bugzilla URLs pointing to users that have ack'd this fix?

	Jeff



