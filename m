Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXGIFpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXGIFpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXGIFox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:44:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbXGIFow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:44:52 -0400
Message-ID: <4691C95F.7080502@zytor.com>
Date: Sun, 08 Jul 2007 22:36:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Kunai, Takashi" <kunai@linux-foundation.jp>
CC: holzheu@linux.vnet.ibm.com, Rob Landley <rob@landley.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, mtk-manpages@gmx.net,
       jack@suse.cz, randy.dunlap@oracle.com, gregkh@suse.de, pavel@ucw.cz,
       tim.bird@am.sony.com, gh@us.ibm.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: Documentation of kernel messages (Summary)
References: <1181747217.29512.9.camel@localhost.localdomain>	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>	 <1182779321.7142.15.camel@localhost.localdomain>	 <200706251144.48658.rob@landley.net> <1182957079.6643.13.camel@localhost.localdomain> <4691C480.5010600@linux-foundation.jp>
In-Reply-To: <4691C480.5010600@linux-foundation.jp>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kunai, Takashi wrote:
> (1) Your kernel development proposal will be greatly supported by
> Japanese vendor community. At the same time, it needs support from the
> kernel communities, as well.

There is a very strong reason for the kernel community to NOT support
this: it makes it much harder to deal with bug reports.

Like it or not, English is a lingua franca[1] of the technology
industry.  When I deal with the rest of the kernel community, I use
English, instead of my native language (Swedish).

For things that are targetted toward end users, that's a different
matter, of course, but kernel messages are inherently directed toward
developers and technically sophisticated users.

	-hpa

