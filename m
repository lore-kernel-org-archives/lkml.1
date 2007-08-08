Return-Path: <linux-kernel-owner+w=401wt.eu-S937414AbXHHUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937414AbXHHUBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXHHUBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:01:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763078AbXHHUBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:01:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Date: Wed, 8 Aug 2007 22:10:24 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Meelis Roos <mroos@linux.ee>
References: <46B9F664.9060600@googlemail.com> <46B9F983.9020700@googlemail.com>
In-Reply-To: <46B9F983.9020700@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082210.25836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 August 2007 19:12, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc2.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> List of Aces
> 
> Name                    Regressions fixed since 21-Jun-2007
> Adrian Bunk                            6
> Andi Kleen                             4
> Andrew Morton                          4
> Linus Torvalds                         4
> Al Viro                                3
> Cornelia Huck                          3
> Jens Axboe                             3
> Tejun Heo                              3
> David Woodhouse                        2
> Hugh Dickins                           2
> Peter Zijlstra                         2
> Trent Piepho                           2
> 
> 
> 
> Power management
> 
> Subject         : Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> References      : http://lkml.org/lkml/2007/8/4/39
> Last known good : ?
> Submitter       : Meelis Roos <mroos@linux.ee>
> Caused-By       : ?
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Status          : unknown

I can't reproduce this with my cross compilation toolchain for PPC.

Greetings,
Rafael
