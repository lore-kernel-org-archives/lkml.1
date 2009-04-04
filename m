Return-Path: <linux-kernel-owner+w=401wt.eu-S937218AbZDDAup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937218AbZDDAup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbZDDAug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:50:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:46504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759541AbZDDAuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:50:35 -0400
Message-ID: <49D6AEA4.3080907@kernel.org>
Date: Fri, 03 Apr 2009 17:49:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make mtrr code could use debugpat
References: <20090329205805.GA24693@elte.hu> <20090329210103.GA24901@elte.hu> <49CFF517.30001@kernel.org> <alpine.LFD.2.00.0903291553210.3948@localhost.localdomain> <1238434120.4529.783.camel@localhost.localdomain> <20090403175555.GH6295@elte.hu> <alpine.LFD.2.00.0904031203400.4015@localhost.localdomain> <20090403212152.GA3493@linux-os.sc.intel.com> <alpine.LFD.2.00.0904031443340.7007@localhost.localdomain> <alpine.LFD.2.00.0904031521460.3915@localhost.localdomain> <20090403222928.GA6446@elte.hu> <49D68F4B.9010808@kernel.org> <alpine.LFD.2.00.0904031737030.3915@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904031737030.3915@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 3 Apr 2009, Yinghai Lu wrote:
>> only print out get_mtrr when debugpat
> 
> Is that get_mtrr message really so interesting that it needs to be printed 
> out at all? Even with debugpat?

or you pick the one in tip/master that remove those line.

YH
