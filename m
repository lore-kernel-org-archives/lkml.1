Return-Path: <linux-kernel-owner+w=401wt.eu-S1763967AbXGFPx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763967AbXGFPx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757948AbXGFPxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:53:50 -0400
Received: from serv07.divms.uiowa.edu ([128.255.44.97]:49039 "EHLO
	serv07.divms.uiowa.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbXGFPxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:53:49 -0400
In-Reply-To: <9a8748490707060821m50e53fc2uba2552ea2e0d07a2@mail.gmail.com>
References: <200707051251.52891.vda.linux@googlemail.com> <20070705143419.f214f5b2.akpm@linux-foundation.org> <6F17353B-D428-462B-B318-2FDEC11E8D66@cs.uiowa.edu> <9a8748490707060821m50e53fc2uba2552ea2e0d07a2@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <25263529-06F1-421B-95B9-5D6CBE8CDB5A@cs.uiowa.edu>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Douglas W. Jones" <jones@cs.uiowa.edu>
Subject: Re: [PATCH 2/2] vsprintf.c: optimizing, part 2: base 10 conversion speedup, v2
Date: Fri, 6 Jul 2007 10:53:40 -0500
To: "Jesper Juhl" <jesper.juhl@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 6, 2007, at 10:21 AM, Jesper Juhl wrote:

> then you just add a line saying
>
>        Signed-off-by: Random J Developer  
> <random@developer.example.org>
>
> using your real name (sorry, no pseudonyms or anonymous  
> contributions.)

If it is necessary, then, this line should be put wherever such
signoffs go:

Signed-off-by: Douglas W Jones <jones@cs.uiowa.edu>

This implies my bemused permission to freely use anything developed
from my tutorials on the web, not my endorsement of what was done
with that material.  I say bemused because it seems far fetched to
claim that I have any ownership interest in this material.  The author
of a tutorial text clearly owns the tutorial organization and
presentation of that text, but to claim ownership of the ideas being
taught is strange.

		Doug Jones
		jones@cs.uiowa.edu
