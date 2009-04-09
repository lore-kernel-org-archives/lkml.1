Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZDIP77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZDIP77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZDIP7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:59:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:51640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZDIP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:59:50 -0400
Subject: Re: Linux 2.6.30-rc1 boot failure on ia64 w/ QLA12160.  Bisected.
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Robin Holt <holt@sgi.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1239291835.3296.16.camel@ht.satnam>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
	 <20090408042734.GD10768@sgi.com>
	 <1239179479.3411.4.camel@macbook.infradead.org>
	 <1239291835.3296.16.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 08:59:32 -0700
Message-Id: <1239292772.2974.18.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 21:13 +0530, Jaswinder Singh Rajput wrote:
> Hello David,
> 
> On Wed, 2009-04-08 at 01:31 -0700, David Woodhouse wrote:
> > On Tue, 2009-04-07 at 23:27 -0500, Robin Holt wrote:
> > > On and ia64 system with a QLA12160 adapter, my boot fails with:
> > 
> > Thanks for the report. After successful feedback from Jeremy, I've added
> > the commit below to git://git.infradead.org/~dwmw2/firmware-2.6.git,
> > which I asked Linus to pull already on Monday...
> 
> you have updated the tree, so better send new pull request to Linus to
> avoid any confusions :-)

The URL is above; he's clever enough to work it out. If he still hasn't
pulled it by the time I get home, I'll send another request.

-- 
dwmw2

