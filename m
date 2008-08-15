Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbYHOPXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbYHOPXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYHOPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:23:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYHOPXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:23:08 -0400
Date: Fri, 15 Aug 2008 17:22:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <npiggin@suse.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [rfc][patch] x86: avoid highmem cache attribute aliasing
Message-ID: <20080815152245.GI10029@elte.hu>
References: <20080801011521.GB20407@wotan.suse.de> <20080811171019.GK4524@elte.hu> <20080811190908.GM13158@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811190908.GM13158@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> [...] But yes, this is a good fix to close the hole.

ok, i've queued it up in tip/x86/pat.

	Ingo
