Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYLSRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYLSRsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYLSRrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:47:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39751 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYLSRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:47:47 -0500
Date: Fri, 19 Dec 2008 19:00:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC]: Support for zero-copy TCP transmit of user space data
Message-ID: <20081219180009.GP25779@one.firstfloor.org>
References: <4941590F.3070705@vlnb.net> <1229022734.3266.67.camel@localhost.localdomain> <4942BAB8.4050007@vlnb.net> <1229110673.3262.94.camel@localhost.localdomain> <49469ADB.6010709@vlnb.net> <20081215231801.GA27168@infradead.org> <4947FA1C.2090509@vlnb.net> <494A97DD.7080503@vlnb.net> <87zlisz9pg.fsf@basil.nowhere.org> <494BDBFC.7060707@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494BDBFC.7060707@vlnb.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, this is why I propose to disable that option by default in 
> distribution kernels, so it would produce no harm.

That would make the option useless for most users. You might as well
not bother merging then.

> first, only then enable that option, then rebuild the kernel. (I'm 
> repeating it to make sure you didn't miss this my point; it was in the 
> part of my original message, which you cut out.)

That was such a ridiculous suggestion, I didn't take it seriously.

Also it should be really not rocket science to use a separate 
table for this.

-Andi

-- 
ak@linux.intel.com
