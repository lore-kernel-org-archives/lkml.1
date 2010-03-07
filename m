Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0CGGSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 01:18:44 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63550 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0CGGSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 01:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <20100307014746.GA28667@oksana.dev.rtsoft.ru>
References: <fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com> 
	<20100305120015.a2008f46.akpm@linux-foundation.org> <fa686aa41003051228w38579483yd4e95bb8eacf40f7@mail.gmail.com> 
	<20100305123527.d6d68e56.akpm@linux-foundation.org> <fa686aa41003051547u1f499902w1d3efc614a9b20b6@mail.gmail.com> 
	<20100306002823.GA22095@oksana.dev.rtsoft.ru> <fa686aa41003051954y3ea8ebebxa915efb74c58dcbb@mail.gmail.com> 
	<20100306050536.GA20539@oksana.dev.rtsoft.ru> <fa686aa41003060843s5b8dfc28p65541056121c4502@mail.gmail.com> 
	<20100307014746.GA28667@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 6 Mar 2010 23:11:01 -0700
X-Google-Sender-Auth: 4bde07ee79a9d908
Message-ID: <fa686aa41003062211i3bf850m29ba0c0acff778b9@mail.gmail.com>
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
To: avorontsov@ru.mvista.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 6:47 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> You could reply to my answers earlier and I would change and
> repost the patches in a jiffy, since I am interested in these
> patches.
>
> But you're obviously not interested in this support since you
> didn't answer my replies. I'll explain. If you were interested
> in some support you could give some chance to make patches
> comfortable to you, and then you could even test them, and
> maybe defend their inclusion.

I'm sorry you feel that way, and I am sorry that I wasn't able to
reply earlier.  I am interested in generic gpio of support, but you
also need to understand that the run up to the merge window is a busy
time as I need to collect all the patches that I'm responsible for and
get them into linux-next for testing well before the merge window
opens.  I do not maintain gpiolib, and it was therefore quite low on
my priority list at that time.  After the merge window closes, I'll
have time to be more responsive again.

Regardless, this series was not going to be merged through any of my
trees because I'm not maintaining gpiolib.  Andrew asked me opinion on
them, and I gave him my answer.  Andrew can make his own decision
about whether or not to merge them, but my opinion still stands.

I'm sorry that I upset you.  It was not my intention.  Please keep in
mind that it is not unusual for patches to take more than one cycle to
get merged.  For example, I've got patches out on the ARM list that
were posted well before the merge window that have neither received
comments, nor will be merged.  I'll pursue them again after this merge
window closes and other maintainers have more bandwidth to make a good
decision about them.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
