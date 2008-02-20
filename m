Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbYBTBSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbYBTBSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYBTBS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:18:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbYBTBSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:18:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
In-Reply-To: Shi Weihua's message of  Wednesday, 20 February 2008 08:49:38 +0800 <47BB7922.1010400@cn.fujitsu.com>
References: <47B95C4D.6080000@cn.fujitsu.com>
	<20080218134720.GA28851@elte.hu>
	<47BA299A.3040207@cn.fujitsu.com>
	<20080219185009.122ED2701BA@magilla.localdomain>
	<47BB7922.1010400@cn.fujitsu.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080220011822.C510B2701BA@magilla.localdomain>
Date: Tue, 19 Feb 2008 17:18:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Please elaborate on the rationale that justifies this change.
> > I don't see it at all.
> 
> I have corrected the comment in the latest patch which has been apllied by Ingo.
> Please refer to http://lkml.org/lkml/2008/2/18/575 and http://lkml.org/lkml/2008/2/19/119 .

You have yet to say anything to justify your change.


Thanks,
Roland
