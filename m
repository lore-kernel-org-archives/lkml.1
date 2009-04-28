Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbZD1Bpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbZD1Bpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZD1Bpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:45:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:41690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZD1Bpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:45:33 -0400
Message-ID: <49F65FA2.4010603@kernel.org>
Date: Tue, 28 Apr 2009 10:45:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>	 <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>
In-Reply-To: <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 01:44:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Dave Airlie wrote:
> My main worry is distro configs going forward, where they pull
> something from defconfig, granted I've no idea if that'll happen,
> maybe distro kernel maintainers are smarter than I give them credit
> for :-)

We're probably as dumb as or even dumber than you give credit for but
we do have testing cycles in place to compensate for it, so I don't
think distros-might-screw-up needs to be a concern when deciding what
gets turned on in defconfig.  :-)

I think defconfig should enable options such that it shows where
upstream kernel is headed, so FWIW +1 for KMS from me.

Thanks.

-- 
tejun
