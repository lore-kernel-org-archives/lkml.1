Return-Path: <linux-kernel-owner+w=401wt.eu-S935619AbZDIPpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935619AbZDIPpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935577AbZDIPoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:44:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:37783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935605AbZDIPoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:44:37 -0400
Subject: Re: Linux 2.6.30-rc1 boot failure on ia64 w/ QLA12160.  Bisected.
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Robin Holt <holt@sgi.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1239179479.3411.4.camel@macbook.infradead.org>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
	 <20090408042734.GD10768@sgi.com>
	 <1239179479.3411.4.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 21:13:55 +0530
Message-Id: <1239291835.3296.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Wed, 2009-04-08 at 01:31 -0700, David Woodhouse wrote:
> On Tue, 2009-04-07 at 23:27 -0500, Robin Holt wrote:
> > On and ia64 system with a QLA12160 adapter, my boot fails with:
> 
> Thanks for the report. After successful feedback from Jeremy, I've added
> the commit below to git://git.infradead.org/~dwmw2/firmware-2.6.git,
> which I asked Linus to pull already on Monday...

you have updated the tree, so better send new pull request to Linus to
avoid any confusions :-)

Thanks,
--
JSR

