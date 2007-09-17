Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXIQWEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXIQWEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbXIQWEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:04:40 -0400
Received: from mail.pro-g.com.tr ([81.214.24.101]:55540 "EHLO
	mail.pro-g.com.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbXIQWEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:04:39 -0400
Message-ID: <46EEFA6D.9080708@pro-g.com.tr>
Date: Mon, 17 Sep 2007 15:06:37 -0700
From: "Can E. Acar" <can.acar@pro-g.com.tr>
User-Agent: Thunderbird 2.0.0.5 (X11/20070729)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Claudio Jeker <cjeker@diehard.n-r-g.com>,
       Adrian Bunk <bunk@kernel.org>, "Can E. Acar" <can.acar@pro-g.com.tr>,
       misc@openbsd.org, linux-kernel@vger.kernel.org,
       Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070917125554.GB13179@diehard.n-r-g.com> <20070917133458.GA18360@thunk.org> <20070917192341.GB30119@diehard.n-r-g.com> <20070917204318.GE18360@thunk.org>
In-Reply-To: <20070917204318.GE18360@thunk.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, Sep 17, 2007 at 09:23:41PM +0200, Claudio Jeker wrote:
>> Because they put their copyright plus license on code that they barely
>> modified. If they would have added substantial work into the OpenHAL code
>> and by doing that creating something new I would not say much.
> 
> Number 1, some of the Linux wireless developers screwed up earlier
> versions.  No denying that, the problems were pointed out during the
> patch reviewed problem, AND THEY WERE FIXED.

Not all, see below:

> Number 2, if you take a look at their latest set of changes (which
> have still not been accepted), the HAL code is under a pure BSD
> license (ath5k_hw.c).  Other portions are dual licensed, but not the
> HAL --- if people would only take a look at
> 
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=tree;f=drivers/net/wireless;h=2d6caeba0924c34b9539960b9ab568ab3d193fc8;hb=everything
> 

from latest ath5k_hw.c:

* Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
* Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
* Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
[snip rest of BSD license]

The only remaining issue is whether Nick & Jiri have enough
original contributions to the code to be added to the Copyright.

I believe this needs to be resolved between Reyk and Nick and Jiri.

The main reason of Theo's message, linked earlier, was the
lack of response on this issue. It seems that the SFLC is
dismissing this issue, and thus stalling its resolution by the
developers.

The rest is, as you say, history.

Can

-- 
In theory, there is no difference between theory and practice.
But, in practice, there is.
