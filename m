Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZELRzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZELRzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZELRzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:55:45 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:6489 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZELRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:55:45 -0400
Message-ID: <4A09B821.8000604@sonarnerd.net>
Date: Tue, 12 May 2009 20:55:45 +0300
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Chris Friesen <cfriesen@nortel.com>, Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net>	 <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net>	 <4A099670.5060902@nortel.com>  <4A09A525.4080107@sonarnerd.net> <1242146758.4792.19.camel@Palantir>
In-Reply-To: <1242146758.4792.19.camel@Palantir>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raistlin wrote:
> Well, I'm not sure I can see why, since nor a "SCHED_MM" scheduling
> policy, nor having priorities for SCHED_OTHER (different from nice
> levels) is _not_ POSIX compliant, is it?

By the way, why is SCHED_IDLE and SCHED_BATCH OK, but not SCHED_MM?

Or is it the name? How about SCHED_INTERACTIVE?


	- Jussi
