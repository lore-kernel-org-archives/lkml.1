Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbXH3S4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbXH3S4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXH3S4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:56:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52644 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbXH3S43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:56:29 -0400
Date: Thu, 30 Aug 2007 20:56:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
In-Reply-To: <20070828214900.5d4b47ad.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708302050270.24730@fbirervta.pbzchgretzou.qr>
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <20070828230459.GA15937@infradead.org>
 <20070828214900.5d4b47ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 21:49, Andrew Morton wrote:
>> 
>> Umm, no way we're ever going to remove a syscall like this.  Please
>> stop this deprecration crap.  Just make sure no ones adds more binary
>> sysctls.
>
>I think it's worth a try.  It might take two, three or five years, who
>knows?  If it turns out to be impractical then we we can just change our
>minds later, no big loss.  It's just too early to say right now.

Great, why do not we remove all the things marked obsolete and
start Linux 2.*newversionbeep*. Just rm, no add, and then tag.

If we never start moving to get rid of the old stuff, we will be
ending up where Microsoft is; though we won't get there as fast since
Linux was designed carefully in the first place and did/does not
collect as much compat dust.


	Jan
-- 
