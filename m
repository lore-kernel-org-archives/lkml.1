Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXJ3Idr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXJ3Idr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXJ3Ida
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:33:30 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:17250 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXJ3Id2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:33:28 -0400
Date: Tue, 30 Oct 2007 10:33:20 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Mark Gross <mgross@linux.intel.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] iommu-PMEN_REG boot up support
Message-ID: <20071030083320.GA8727@rhun.ibm.com>
References: <20071026181849.GA25256@linux.intel.com> <20071027001938.GB10215@rhun.ibm.com> <20071029203130.GA1734@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029203130.GA1734@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 01:31:30PM -0700, Mark Gross wrote:

> > What's the value of adding a command line option for this? Under
> > what circumstances would we want to not clear this bit?
> 
> umm, /me asks around and finds out that at this time there isn't
> much point to having a command line to preserve any protected areas
> set up at boot time.

The society for controlled proliferation of command line options
thanks you.

> Signed-off-by: mark gross <mgross@linux.intel.com>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
