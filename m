Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYFBKm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYFBKm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYFBKmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:42:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbYFBKmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:42:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Date: Mon, 2 Jun 2008 12:43:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <1212010931.3445.103.camel@localhost.localdomain> <20080529163247.GW22636@parisc-linux.org> <Pine.LNX.4.64.0806021231220.6718@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806021231220.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021243.33976.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 2 of June 2008, Jiri Kosina wrote:
> On Thu, 29 May 2008, Matthew Wilcox wrote:
> 
> > > - fixing random bugs from kernel bugzilla is boring (spending 10 hours 
> > >   looking for missing '=' doesn't really attract them)
> > Perhaps you could try making the process of finding a kernel bug seem
> > more exciting?  I doubt that most kernel bugs are a simple as a missing =.
> 
> Indeed. Large amount of kernel bugs is 'kernel doesn't work on this 
> hardware setup X, other hardware setups are not affected". That doesn't 
> sound too sexy either, unless you are unfortunate enough to have the piece 
> of hardware in question, of course.

Well, if you test linux-next or -mm on a regular basis, you are almost
guaranteed to encounter a bug that manifests itself on your hardware, sooner
or later. :-)

Thanks,
Rafael
