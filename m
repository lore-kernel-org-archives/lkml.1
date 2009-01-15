Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbZAOSA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbZAOSA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZAOSAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:00:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZAOSAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:00:01 -0500
From: Andreas Schwab <schwab@suse.de>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
       IA64 <linux-ia64@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com, "David S. Miller" <davem@davemloft.net>,
       SPARC <sparclinux@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash: IP: [<ffffffff80478092>] __bitmap_intersects+0x48/0x73 [PATCH supplied]
References: <496BF6D5.9030403@sgi.com> <20090113130048.GB31147@elte.hu>
	<496CAF5A.3010304@sgi.com> <496D0F46.2010907@sgi.com>
	<496D2172.6030608@sgi.com> <20090114165431.GA18826@elte.hu>
	<20090114165524.GA21742@elte.hu> <20090114175126.GA21078@elte.hu>
	<496E78BA.5040609@sgi.com> <20090115101428.GG5833@elte.hu>
	<496F67D8.4060507@sgi.com>
X-Yow: NOW, I'm supposed to SCRAMBLE two, and HOLD th' MAYO!!
Date: Thu, 15 Jan 2009 18:59:54 +0100
In-Reply-To: <496F67D8.4060507@sgi.com> (Mike Travis's message of "Thu, 15 Jan
	2009 08:44:08 -0800")
Message-ID: <jepriolaat.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

>  23> git-remote update
> Updating linus
> Updating tip

This only updates the remotes, but does not merge anything into your
local branch.  You need to run "git merge tip" to do that.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
