Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbXEUW3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbXEUW3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759449AbXEUW25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:28:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759410AbXEUW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:28:56 -0400
Message-ID: <46521BFD.7040703@redhat.com>
Date: Mon, 21 May 2007 18:23:57 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [patch 00/69] -stable review
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org> <20070521222004.GT6291@stusta.de>
In-Reply-To: <20070521222004.GT6291@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, May 21, 2007 at 12:31:48PM -0700, Andrew Morton wrote:
>> On Mon, 21 May 2007 12:16:12 -0700
>> Chris Wright <chrisw@sous-sol.org> wrote:
>>
>>> This is the start of the stable review cycle for the 2.6.21.2 release.
>> Gee a lot of these are fixing recently-added regressions :(
>> ...
> 
> If only it would fix all of them...
> 
> Michal's list [1] currently contains 51 different regressions in
> 2.6.21 compared to 2.6.20 (12 of them were already reported before
> 2.6.21 was released).

Yeah, 2.6.21 seems awfully buggy, and patches to fix many of the bugs
haven't appeared.

Another 2.6.20 update seems to be in order...

