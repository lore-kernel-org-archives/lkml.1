Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXLOH5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXLOH5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXLOH4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:56:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbXLOH4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:56:52 -0500
Date: Sat, 15 Dec 2007 08:55:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: ebiederm@xmission.com, venkatesh.pallipadi@intel.com, ak@muc.de,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Message-ID: <20071215075539.GF12110@elte.hu>
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com> <m1d4taq6le.fsf@ebiederm.dsl.xmission.com> <m1wsrhq4zl.fsf@ebiederm.dsl.xmission.com> <20071214211039.GB717@linux-os.sc.intel.com> <20071214233401.GE717@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214233401.GE717@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> > Ok. I will send a separate patch fixing ioremap_nocache on x86.
> 
> Appended the patch. x86 folks, please consider for x86 mm git tree. 
> Thanks.

thanks, applied.

	Ingo
