Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYE1FRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYE1FRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYE1FRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:17:10 -0400
Received: from smtp.nokia.com ([192.100.122.230]:22147 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYE1FRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:17:09 -0400
Message-ID: <483CEA50.4050902@yandex.ru>
Date: Wed, 28 May 2008 08:14:56 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Artem.Bityutskiy@nokia.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: can UBIFS be taken to linux-next?
References: <483BA79F.9030100@nokia.com> <20080528114112.b8600074.sfr@canb.auug.org.au>
In-Reply-To: <20080528114112.b8600074.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2008 05:16:21.0711 (UTC) FILETIME=[F794FDF0:01C8C081]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> OK, my requirements are that you intend for it to be integrated in the
> next merge window,
Yes.

> that it be reviewed 
We have not got too much review, just because there are not so many people
involved into the area. But we have got some review. The best one was
from Christoph Hellwig.

> and that it be unit tested (i.e.
> tested as well as you can in isolation). 
Yes, we do this on regular basis. We have our own tests [1] ans we use
older JFFS2 tests [2]. We also use it in Nokia and we have several users
in the community.

> You seem to have done all that,
> so I will add it.
Thanks.

[1] git://git.infradead.org/~dedekind/ubifs-userspace.git
or  http://git.infradead.org/users/dedekind/ubifs-userspace.git
[2] git://git.infradead.org/mtd-utils.git
or http://git.infradead.org/mtd-utils.git

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
