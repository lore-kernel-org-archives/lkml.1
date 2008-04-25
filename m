Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbYDYJNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbYDYJNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbYDYJND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:13:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36151
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758819AbYDYJNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:13:01 -0400
Date: Fri, 25 Apr 2008 02:13:01 -0700 (PDT)
Message-Id: <20080425.021301.193689806.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
From: David Miller <davem@davemloft.net>
In-Reply-To: <4812108D.6020103@gmail.com>
References: <4811090A.9030809@gmail.com>
	<alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
	<4812108D.6020103@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 25 Apr 2008 19:10:37 +0200

> I'm going to bisect it, will be back in few hours ;).

Thanks for all of this hard work and investigation Jiri!
