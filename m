Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXFYBfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXFYBfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXFYBew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:34:52 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56909 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbXFYBev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:34:51 -0400
Message-ID: <467F1ADE.10803@gmail.com>
Date: Mon, 25 Jun 2007 03:31:10 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Arjan van de Ven <arjan@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <467F191C.9090506@gmail.com>
In-Reply-To: <467F191C.9090506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 03:23 AM, Rene Herman wrote:

> On 06/25/2007 02:41 AM, Adrian Bunk wrote:
> 
>> The interesting questions are:
>> Does -Os still sometimes generate faster code with gcc 4.2?
>> If yes, why?
> 
> I would wager that the CPU type makes more of a difference than the 
> compiler version. That is, I'd expect my Duron with it's "puny" 64K L1 
> to have a very different profile than it's Athlon brother with 256K L1.

Sorry, that should've been L2. And "its" ...

  > Not to mention CPUs with as little as 8K L1 (P1).
> 
> I can't quote numbers -- it's a bit hard to test those things anyway as 
> it's a system-global effect and not su much that's easily isolated in a 
> dedicated benchmark.

And while I'm at it, "and not so much one that's [ ...]".

Rene.
