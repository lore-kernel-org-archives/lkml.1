Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZJWOiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZJWOiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZJWOiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:38:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46649 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZJWOiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:38:03 -0400
Date: Fri, 23 Oct 2009 16:37:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Yinghai Lu <yinghai@kernel.org>, Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091023143714.GA9719@elte.hu>
References: <1394846127@web.de> <20091023133152.1a15ba69@jbarnes-x200> <1256273896.2569.10.camel@sbs-t61> <200910230924.54655.thomas.schlichter@web.de> <1256307876.2561.8.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256307876.2561.8.camel@sbs-t61>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Fri, 2009-10-23 at 00:24 -0700, Thomas Schlichter wrote:
> > Hmm, at this point I already was more than a week ago:
> >   http://marc.info/?l=linux-kernel&m=125537770514713&w=2
> > 
> > OK, I also modified ioremap() and set_memory_wc() but your patch is just part 
> > of what I did there...
> 
> oops! Sorry I read the later emails in this thread carefully but not 
> the conversation with Thomas Hellstrom. Anyhow, glad that you were on 
> top of this. Thanks.
> 
> Ingo, can you please queue this patch with a sign-off from Thomas 
> Schlichter too?

Please resend the latest with all the acks/signoffs added, with the 
subject line changed to '[PATCH] ...' and all people Cc:-ed.

Thanks,

	Ingo
