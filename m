Return-Path: <linux-kernel-owner+w=401wt.eu-S2992874AbXDDLtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992874AbXDDLtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992875AbXDDLtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:49:31 -0400
Received: from ns.suse.de ([195.135.220.2]:44012 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992874AbXDDLta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:49:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable entries
Date: Wed, 4 Apr 2007 13:49:27 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <20070402055652.610711908@goop.org> <46136F25.7030907@goop.org> <20070404095745.GA16726@elte.hu>
In-Reply-To: <20070404095745.GA16726@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041349.27459.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > paravirt, patching
> > ezr       Linux 2.6.21- 1000 0.25 0.53 31.8 34.4 10.1 1.04 5.44 730. 1583 4600
> > ezr       Linux 2.6.21- 1000 0.26 0.55 32.1 35.2 13.3 1.03 5.48 748. 1589 4606
> > ezr       Linux 2.6.21- 1000 0.26 0.54 32.0 34.9 14.1 1.04 5.43 752. 1606 4647
> 
> i guess this pretty much makes the case for patching ...

Yes, we definitely want to patch. Still it's unclear why it still shows slower stat.
Or could that be benchmark noise?

-Andi

