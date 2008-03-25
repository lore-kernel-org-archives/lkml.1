Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbYCYXEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbYCYXEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYCYXEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:04:37 -0400
Received: from mail.suse.de ([195.135.220.2]:35303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbYCYXEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:04:36 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Dean Nelson" <dcn@sgi.com>, <jes@sgi.com>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
Subject: Re: [Patch 0/5] prepare XPC and XPNET to support SGI UV
References: <20080325192524.343385569@attica.americas.sgi.com>
	<20080325201423.GB4446@sgi.com>
	<1FE6DD409037234FAB833C420AA843ECE9E1AB@orsmsx424.amr.corp.intel.com>
X-Yow: My DIGITAL WATCH has an automatic SNOOZE FEATURE!!
Date: Wed, 26 Mar 2008 00:04:34 +0100
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE9E1AB@orsmsx424.amr.corp.intel.com>
	(Tony Luck's message of "Tue\, 25 Mar 2008 15\:49\:46 -0700")
Message-ID: <jeve3aiewt.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luck, Tony" <tony.luck@intel.com> writes:

> I think git has an option to produce its own brand of diff output
> that lists the renames without doing a full remove & add which is
> needed for patch(1) comprehensibility.  A few minutes staring at
> git documentation hasn't revealed what that option is though :-(

$ git diff -M

or "git config --global diff.renames true" to make it permanent.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
