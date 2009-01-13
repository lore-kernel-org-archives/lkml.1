Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbZAMXbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbZAMXbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbZAMXaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:30:46 -0500
Received: from xenotime.net ([72.52.64.118]:51622 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753764AbZAMXap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:30:45 -0500
Message-ID: <496D2417.4030705@xenotime.net>
Date: Tue, 13 Jan 2009 15:30:31 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: David Newall <davidn@davidnewall.com>, Daolong Wang <ahlongxp@gmail.com>,
       David Miller <davem@davemloft.net>, bhutchings@solarflare.com,
       lizf@cn.fujitsu.com, qhfeng.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: fix wrong English expression in comments
References: <496a3c51.09876e0a.03fe.7e80@mx.google.com> <496A9753.80802@cn.fujitsu.com> <1231724358.2674.13.camel@hashbaz.i.decadent.org.uk> <20090112.215320.197154233.davem@davemloft.net> <dc84318c0901122216s77bae26eo2dd36c4a0ee35177@mail.gmail.com>            <496C53AF.3080901@davidnewall.com> <25981.1231888978@turing-police.cc.vt.edu>
In-Reply-To: <25981.1231888978@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 13 Jan 2009 19:11:19 +1030, David Newall said:
>> Daolong Wang wrote:
>>> The patch will make sense for some people. I was puzzled about the
>>> double-negative for quite a while.
>>>   
>> "Don't add nothing," is not a colloquialism; it's just bad grammar.  The
>> meaning is that you must not add no thing, therefore that you must add
>> something.  It is a common error amongst English speakers, even amongst
>> those who speak good, but.  :-)
> 
> Those of us who have worked with weakly-typed languages who have coded
> stuff like 'X + 0.0' to cast X from string to floating point know all
> too well that sometimes, adding nothing is in fact what you want to do.

That didn't sway the argument^W discussion IMO.

for the patch:  Acked-by: Randy Dunlap <rdunlap@xenotime.net> // :)


~Randy
