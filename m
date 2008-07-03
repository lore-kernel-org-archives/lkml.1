Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYGCRgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYGCRgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYGCRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:35:51 -0400
Received: from smtp-01.datacomm.ch ([212.40.2.26]:56863 "EHLO
	smtp-01.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbYGCRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:35:51 -0400
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <484FE97D.4040805@firstfloor.org>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <200806090036.32267.rjw@sisk.pl>
	 <1213184587.6376.37.camel@localhost.localdomain>
	 <200806111638.50933.rjw@sisk.pl>  <484FE97D.4040805@firstfloor.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 19:35:47 +0200
Message-Id: <1215106548.5194.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*bump*

Why "too late" ??? It (2.6.26) is still not out! Please (;-) oh please!)
reconsider / push it a bit! It's tested and working perfectly here ever
since. But I'd like for example vmware to work again as will and it
doesn't yet even with 2.6.25... Please let this patch go into 2.6.26 so
there's a chance of having a stock kernel with working vmware, fglrx,
and such again soon!

Thx

Greets - Patrick

On Mit, 2008-06-11 at 17:04 +0200, Andi Kleen wrote:
> > Well, I was hoping to be able to get this patch into 2.6.26, as I don't really
> > like the temporary hack, preventing the affected systems from resuming
> > at all, that we have in there, but it seems to be too late. :-(
> 
> I agree with you that this patch would be far better than the hack.
> 
> -Andi

