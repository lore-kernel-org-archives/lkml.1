Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZIUUfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZIUUfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZIUUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:35:07 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39752 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbZIUUfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:35:07 -0400
Date: Mon, 21 Sep 2009 22:35:09 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: depend on HAVE_ARCH_KMEMCHECK
Message-ID: <20090921203509.GA648@Chamillionaire.breakpoint.cc>
References: <20090628111019.GA15900@Chamillionaire.breakpoint.cc>
 <4A474EFF.5030607@cs.helsinki.fi>
 <19f34abd0907011327h7e90ec68r7ad0ed8666abafac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <19f34abd0907011327h7e90ec68r7ad0ed8666abafac@mail.gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vegard Nossum | 2009-07-01 22:27:32 [+0200]:

>2009/6/28 Pekka Enberg <penberg@cs.helsinki.fi>:
>> Sebastian Andrzej Siewior wrote:
>>>
>>> to make it selectable if it is available
>>>
>>> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>>
>> Looks good to me! Thanks.
>>
>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
>Applied, thanks.

This patch did not make it into v31. Do you thing it is possible that it
will reach v32?

>Vegard

Sebastian
