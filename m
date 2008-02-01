Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYBASI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYBASI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYBASIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:08:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:46923 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYBASIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:08:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,291,1199692800"; 
   d="scan'208";a="256192788"
Date: Fri, 1 Feb 2008 10:08:23 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jike Song <albcamus@gmail.com>, Rijndael Cosque <rijcos@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's the status of x2APIC support in Linux kernel?
Message-ID: <20080201180822.GA376@linux-os.sc.intel.com>
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com> <df9815e70802010053n4565397dofd847373df522e5c@mail.gmail.com> <p73fxwc50s5.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73fxwc50s5.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 01:17:14PM +0100, Andi Kleen wrote:
> "Jike Song" <albcamus@gmail.com> writes:
> 
> > On 2/1/08, Rijndael Cosque <rijcos@gmail.com> wrote:
> >> Hi all,
> >>
> >> I found the x2APIC spec via http://www.intel.com/products/processor/manuals/.
> >>
> >> Looks at present there is no x2APIC support in Linux kernel 2.6.24?
> >>
> >> Is there any experimental patch available for Linux kernel? -- I
> >> googled "x2APIC Linux";  looks no patch for now?
> 
> There are right no CPUs shipping which implement x2apic.

That's correct. None of the released CPU's support it.

I am working on a patch enabling these future x2apic extensions and the plan 
is to post this kernel patch shortly.

thanks,
suresh
