Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZJ3LGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZJ3LGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 07:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbZJ3LGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 07:06:17 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64162 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbZJ3LGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 07:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=cVzbnZ9c4fCn4LJVI4yLLPbKn+KECCm/lnHMw/p+6732l9M4idSsZiMy611JKUqjkb
         t/iW+gLcVtNx/oTocrlY1Xt+wy1bboMJVVI/Y3Q6ZXNKgXMlwqTrBYEGZ/J1ecWf2DKV
         gDVPQZPa9Gt4bDe2Qqva3hVEnhxX+SeNeKceU=
Date: Fri, 30 Oct 2009 11:06:16 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Message-ID: <20091030110616.GB6150@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256886023.3555.5.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-10-2009 08:00, Johannes Berg wrote:
> On Thu, 2009-10-29 at 22:48 +0100, Bartlomiej Zolnierkiewicz wrote:
> 
>> I don't think that my technical arguments are pointless.
>>
>> Quite the contrary, I'm pretty confident that addressing my review concerns
>> would result in better RT28x00 / RT30x0 support in the very near future.
> 
> So you know how to make the driver better, whine that it doesn't work,
> but don't help out either. Hey, good way to collaborate!
> 
>>> It should be pretty obvious by now that the best way to improve things
>>> is to work with the relevant maintainers, not against them. (Unless
>>> you wish your work to be ignored, of course.)
>> I work with a lot of other maintainers.  I would say that providing valuable
>> review feedback is also "working with" (at least I would be very happy with
>> such feedback in my projects).
> 
> Face it though, people have read your feedback, thought about it, and
> decided to disagree. You seem to have a childish problem with that,
> appealing to higher authority to get your way just makes you look more
> childish.

There are various ways to disagree, and ignoring by John questions
from a merited developer both in this referenced lkml and current
threads looks at least strange (if not offensive) as well.

Jarek P.
