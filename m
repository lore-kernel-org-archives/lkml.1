Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbYBBThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbYBBThm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbYBBThe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:37:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbYBBThd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:37:33 -0500
Date: Sat, 2 Feb 2008 20:37:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, shaohua.li@intel.com, auke-jan.h.kok@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       matthew@wil.cx, venkatesh.pallipadi@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bootup crash, -git] Re: patch pci-pcie-aspm-support.patch
	added to gregkh-2.6 tree
Message-ID: <20080202193714.GA32039@elte.hu>
References: <1201141317.26118.2.camel@sli10-desk.sh.intel.com> <12013009171835@kroah.org> <20080202105506.GA25160@elte.hu> <20080202185145.GA13005@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202185145.GA13005@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> Ugh, this is causing just too many problems, I'm just going to revert 
> it.
> 
> Shaohua, care to look into this crash, fix up the config issues, and 
> resubmit it when it's working a bit better?

i can test any patches, the crash was fully reproducible. It's probably 
something rather trivial - i dont have the hardware so it should just 
have bailed out.

	Ingo
