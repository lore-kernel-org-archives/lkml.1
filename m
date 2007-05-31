Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbXFACJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbXFACJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbXFACJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:09:24 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33023
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbXFACJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:09:22 -0400
X-Greylist: delayed 10065 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 22:09:22 EDT
Date: Fri, 1 Jun 2007 01:21:33 +0200
From: andrea@cpushare.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - works-for-me and a meta-question...
Message-ID: <20070531232133.GB4166@v2.random>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <10478.1180649104@turing-police.cc.vt.edu> <6bffcb0e0705311527ge774f48s8014f5108556f651@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0705311527ge774f48s8014f5108556f651@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 01, 2007 at 12:27:02AM +0200, Michal Piotrowski wrote:
> On 01/06/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> >On Wed, 30 May 2007 23:58:23 PDT, Andrew Morton said:
> >> 
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> >
> >Builds, boots, seems to be behaving on my laptop (Dell D820, X86_64).
> >
> >Meta-question: Is there a useful address/mailbox/webpage to toss *working*
> >reports at?
> >
> 
> There was a klive
> http://klive.cpushare.com/
> 
> Actually it doesn't work. Andrea, what is happening with klive?

Don't worry, everything is going fine at klive.cpushare.com. You only
clicked it at the wrong time ;). (by the time I read your message it
was back up already) Uptime has generally been very good...

KLive current problem is that 512M of shm for the db, isn't enough to
get good performance with the current data size anymore.
