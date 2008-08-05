Return-Path: <linux-kernel-owner+w=401wt.eu-S1763721AbYHEVJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763721AbYHEVJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbYHEVJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:09:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:32905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbYHEVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:09:12 -0400
Date: Tue, 5 Aug 2008 14:08:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080805140852.24215700@infradead.org>
In-Reply-To: <1217969467.27684.179.camel@localhost.localdomain>
References: <20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805181141.GA10700@kroah.com>
	<2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	<20080805201816.GD27192@kroah.com>
	<2629CC4E1D22A64593B02C43E855530304AE4ADA@USILMS12.ca.com>
	<1217969467.27684.179.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008 16:51:07 -0400
Eric Paris <eparis@redhat.com> wrote:

> I think Alan and I have both described how greater linux security can
> be gained through this interface compared to glibc or LD_PRELOAD even
> if it isn't perfect security.  

I guess I missed that.

I will fully subscribe to the idea that  "the LD_PRELOAD way assumes you
have a good->bad transition" might not be fully bullet proof (after
all, if your init is compromised you won't have this transition)

but what else is the actual gap?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
