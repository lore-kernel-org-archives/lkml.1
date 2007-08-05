Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbXHEQiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbXHEQiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXHEQio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:38:44 -0400
Received: from ns.suse.de ([195.135.220.2]:59425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbXHEQin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:38:43 -0400
Subject: Re: [2/2] 2.6.23-rc2: known regressions with patches
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Dittmer <jdi@l4x.org>, Netdev <netdev@vger.kernel.org>,
       Joachim Deguara <joachim.deguara@amd.com>,
       Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, Seokmann Ju <seokmann.ju@qlogic.com>,
       Richard Lary <rlary@us.ibm.com>, tony.luck@intel.com
In-Reply-To: <46B5FA4C.2070700@googlemail.com>
References: <46B5F93A.1020100@googlemail.com>
	 <46B5FA4C.2070700@googlemail.com>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 18:39:36 +0200
Message-Id: <1186331976.3858.39.camel@fanta4.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 18:26 +0200, Michal Piotrowski wrote:
> Hi all,

> Modpost
> 
> Subject         : modpost bug breaks ia64 cross compilation
> References      : http://lkml.org/lkml/2007/7/27/30
>                   http://lkml.org/lkml/2007/7/27/418
> Last known good : ?
> Submitter       : Jan Dittmer <jdi@l4x.org>
> Caused-By       : Thomas Renninger <trenn@suse.de>
>                   commit 29b71a1ca74491fab9fed09e9d835d840d042690
> Handled-By      : ?
> Patch           : http://lkml.org/lkml/2007/8/2/211
> Status          : patch was suggested

A patch was sent to Tony. AFAIK it got accepted, not sure whether it
already is in any and which git tree...

> Networking
> 
> Subject         : tg3 dead after s2ram
> References      : http://lkml.org/lkml/2007/7/31/121
> Last known good : ?
> Submitter       : Joachim Deguara <joachim.deguara@amd.com>
> Caused-By       : ?
> Handled-By      : Michael Chan <mchan@broadcom.com>
> Patch           : http://lkml.org/lkml/2007/8/2/288
> Status          : patch available
> 
David Miller sent a message that it got applied.

Thanks,

   Thomas

