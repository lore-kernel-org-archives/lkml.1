Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYBNTFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYBNTFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbYBNTFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:05:00 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:44584 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbYBNTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:04:59 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: What's the status of x2APIC support in Linux kernel?
Date: Thu, 14 Feb 2008 12:06:37 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <andi@firstfloor.org>, Jike Song <albcamus@gmail.com>,
       Rijndael Cosque <rijcos@gmail.com>, linux-kernel@vger.kernel.org
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com> <p73fxwc50s5.fsf@bingen.suse.de> <20080201180822.GA376@linux-os.sc.intel.com>
In-Reply-To: <20080201180822.GA376@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141206.37542.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 11:08:23 am Siddha, Suresh B wrote:
> On Fri, Feb 01, 2008 at 01:17:14PM +0100, Andi Kleen wrote:
> > "Jike Song" <albcamus@gmail.com> writes:
> > 
> > > On 2/1/08, Rijndael Cosque <rijcos@gmail.com> wrote:
> > >> Hi all,
> > >>
> > >> I found the x2APIC spec via http://www.intel.com/products/processor/manuals/.
> > >>
> > >> Looks at present there is no x2APIC support in Linux kernel 2.6.24?
> > >>
> > >> Is there any experimental patch available for Linux kernel? -- I
> > >> googled "x2APIC Linux";  looks no patch for now?
> > 
> > There are right no CPUs shipping which implement x2apic.
> 
> That's correct. None of the released CPU's support it.
> 
> I am working on a patch enabling these future x2apic extensions and the plan 
> is to post this kernel patch shortly.

Are you adding x2apic support for both x86 and ia64, or only for x86?

Bjorn
