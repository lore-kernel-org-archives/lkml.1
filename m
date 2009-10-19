Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZJSP32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZJSP32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbZJSP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:29:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbZJSP3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:29:24 -0400
Date: Mon, 19 Oct 2009 17:28:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, JBeulich@novell.com,
       arjan@linux.intel.com, dri-devel@lists.sourceforge.net,
       hancockrwd@gmail.com, hmh@hmh.eng.br, hpa@zytor.com,
       jbarnes@virtuousgeek.org, jeremy.fitzhardinge@citrix.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       thellstrom@vmware.com, tj@kernel.org, venkatesh.pallipadi@intel.com,
       x86@kernel.org, yinghai@kernel.org
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091019152833.GA17993@elte.hu>
References: <1392925495@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392925495@web.de>
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


* Thomas Schlichter <thomas.schlichter@web.de> wrote:

> > We can make PAT configurability dependent on EMBEDDED-y - mind 
> > sending a patch for that?
> 
> I think there already is such a patch in -tip: 
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=c03cb3149daed3e411657e3212d05ae27cf1a874

Yes :-)

	Ingo
