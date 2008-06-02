Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbYFBRlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbYFBRlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbYFBRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:40:13 -0400
Received: from www17.your-server.de ([213.133.104.17]:33346 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174AbYFBRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:40:11 -0400
Message-ID: <1212428404.484430742e07d@213.133.104.17>
Date: Mon, 02 Jun 2008 19:40:04 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: linux-next: Tree for May 30
References: <20080530181901.8268f317.sfr@canb.auug.org.au> <1212316424.3253.8.camel@dhcppc1> <20080601150710.GB27843@elte.hu>
In-Reply-To: <20080601150710.GB27843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 88.68.108.184
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von Ingo Molnar <mingo@elte.hu>:

> hm, that commit is gone in latest tip - does tip/master boot fine for 
> you? It's:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> that commit was an interim fix that got removed meanwhile and replaced 
> with the real fixes.

I just booted next-20080602 successfully, and the latest commit on file
arch/x86/kernel/setup_32.c is:

4efc5450e19128e0c77fbfdf4a14804f5a4a1d95 (Merge branch 'x86/numa' into
auto-x86-next).

So yes, the original commit causing the error for me is gone.

Thanks and greets.
thomas

