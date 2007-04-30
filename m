Return-Path: <linux-kernel-owner+w=401wt.eu-S1423529AbXD3SK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423529AbXD3SK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946566AbXD3SK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:10:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33568 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946548AbXD3SKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:10:34 -0400
Date: Mon, 30 Apr 2007 20:10:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Miller <davem@davemloft.net>
Cc: mangoo@wpkg.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
Message-ID: <20070430181045.GD23336@stusta.de>
References: <46358809.4070909@wpkg.org> <20070430.000138.17862632.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070430.000138.17862632.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 12:01:38AM -0700, David Miller wrote:
>...
> If bugs should be reported to the mailing list, then they
> should just get rid of bugzilla because it's aparently
> serving as a garbage bin.

The first question is not "Bugzilla" but "Does bug tracking make sense?".

Many bug reports to linux-kernel get zero attention and are lost without 
tracking. Is losing bug reports OK or do we need a tracking of bugs?

Tracking means:
- not to miss bug reports
- record discussions and the status of the bugs
- the real value comes from:
  provide useful reports like "all open ACPI bugs" or "all 2.6.21-rc 
  regressions" to people who are actually working on fixing the bugs

I was tracking 2.6.21-rc regressions.
Some people said this was useful.

Manually tracking of three dozen regressions plus sending regular sorted 
reports was at the limit of what I am able to handle manually without 
any tracking tool.

There are two different questions that seem to often be mixed in 
discussions:

The first question is:
Does it make sense to track kernel bugs?

If no, there's no need to discuss Bugzilla or other tools.

If yes, the second question is:
Which tracking tool would make sense for the Linux kernel?
This could be Bugzilla, the Debian bug tracking system, or even 
something written from scratch.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

