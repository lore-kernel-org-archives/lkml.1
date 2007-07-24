Return-Path: <linux-kernel-owner+w=401wt.eu-S1765523AbXGXOe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765523AbXGXOe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXGXOeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:34:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43090 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbXGXOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:34:18 -0400
Date: Tue, 24 Jul 2007 16:33:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: jschopp <jschopp@austin.ibm.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-ID: <20070724143342.GB6019@stusta.de>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com> <46A60581.90800@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46A60581.90800@austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 08:58:25AM -0500, jschopp wrote:
>> within the last 3 weeks, this script went from *really usable* to *a big 
>> noise maker*.
>
> As we (mostly Andy of late) add more checks (good) there is bound to be 
> some code we just didn't forsee that generates false positives (bad).  You 
> can see a consistent history of cleaning these up as quickly as people send 
> them in.  Hopefully in the interim there aren't too many false positives 
> and the script is still useful.  We do try to put the new tests through 
> their paces before adding them in, but our imaginations are limited.
>
> The goal has always been to err on the side of missing badness in code to 
> avoid false positives. This way, when there is output it has a very high 
> chance of not wasting your time.  Wait a couple weeks and it'll be there 
> again.
>...

And it will be known as "noise maker" for years, even if that'll be 
fixed in a few weeks...

Running it on the latest -rc or -mm should usually give good hints 
whether the output has become better or worse.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

