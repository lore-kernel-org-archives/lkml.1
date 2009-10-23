Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZJWOZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZJWOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZJWOZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:25:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:42143 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZJWOZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:25:26 -0400
X-ExtLoop1: 1
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
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
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockrwd@gmail.com>
In-Reply-To: <200910230924.54655.thomas.schlichter@web.de>
References: <1394846127@web.de> <20091023133152.1a15ba69@jbarnes-x200>
	 <1256273896.2569.10.camel@sbs-t61>
	 <200910230924.54655.thomas.schlichter@web.de>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 23 Oct 2009 07:24:36 -0700
Message-Id: <1256307876.2561.8.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 00:24 -0700, Thomas Schlichter wrote:
> Hmm, at this point I already was more than a week ago:
>   http://marc.info/?l=linux-kernel&m=125537770514713&w=2
> 
> OK, I also modified ioremap() and set_memory_wc() but your patch is just part 
> of what I did there...

oops! Sorry I read the later emails in this thread carefully but not the
conversation with Thomas Hellstrom. Anyhow, glad that you were on top of
this. Thanks.

Ingo, can you please queue this patch with a sign-off from Thomas
Schlichter too?

thanks,
suresh

