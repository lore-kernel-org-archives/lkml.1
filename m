Return-Path: <linux-kernel-owner+w=401wt.eu-S2992617AbXEBAx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992617AbXEBAx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992634AbXEBAx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:53:59 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45846 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992617AbXEBAx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:53:58 -0400
Date: Tue, 1 May 2007 17:52:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chuck Ebbert <cebbert@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge plans)
Message-ID: <20070502005212.GY2819@sequoia.sous-sol.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org> <463688AD.1050903@garzik.org> <20070501004036.GS2819@sequoia.sous-sol.org> <46368DA5.7070003@garzik.org> <20070501045806.GA3697@kroah.com> <46376748.6020408@redhat.com> <20070501174033.2046f289@the-village.bc.nu> <20070501233419.GA10462@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501233419.GA10462@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> And is this really a problem?  The whole goal of the -stable tree was to
> accomidate the users who relied on kernel.org kernels, and wanted
> bugfixes and security updates.  It was not for new features or new
> hardware support.
> 
> If people feel we should revisit this goal, then that's fine, and I have
> no objection to that.  But until then, I think the rules that we have
> had in place for over the past 2 years should still remain in affect.

I have to agree.  I went back through my mbox and found vanishingly few
pci_id update patches.   So it's not clear there's even a big issue.

thanks,
-chris
