Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbYHGVWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbYHGVWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYHGVW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:22:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47390 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYHGVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:22:27 -0400
Date: Thu, 7 Aug 2008 10:17:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: Patrick <ragamuffin@datacomm.ch>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
Message-ID: <20080807081747.GC1647@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain> <200806090036.32267.rjw@sisk.pl> <1213184587.6376.37.camel@localhost.localdomain> <200806111638.50933.rjw@sisk.pl> <484FE97D.4040805@firstfloor.org> <1215106548.5194.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215106548.5194.22.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> *bump*
> 
> Why "too late" ??? It (2.6.26) is still not out! Please (;-) oh please!)
> reconsider / push it a bit! It's tested and working perfectly here ever
> since. But I'd like for example vmware to work again as will and it
> doesn't yet even with 2.6.25... Please let this patch go into 2.6.26 so
> there's a chance of having a stock kernel with working vmware, fglrx,
> and such again soon!

Can you test 2.6.27-rc2? It should be all there...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
