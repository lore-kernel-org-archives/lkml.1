Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbXHRJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbXHRJ7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbXHRJ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:59:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51592 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXHRJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:59:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46C6C2D5.205@s5r6.in-berlin.de>
Date: Sat, 18 Aug 2007 11:58:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Xu Yang <risingsunxy@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.19 porting
References: <ab40e9c0708170924h5b958423jcd0e82e211ca8463@mail.gmail.com> <20070818052805.GO6002@1wt.eu>
In-Reply-To: <20070818052805.GO6002@1wt.eu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Fri, Aug 17, 2007 at 06:24:17PM +0200, Xu Yang wrote:
>> I have built up a software virtual prototype system with ARM11MPCORE.
>> my system is similar with realview_eb_mpcore. but my system is
>> simpler, which has only a mpcore , uart0, console,timer0_1, and
>> memorys.
>>
>> I want to run kernel 2.6.19 on it.
...
> If you upgrade to a more recent kernel (eg: 2.6.22), you'll get
> more feedback because it's fresher in people's mind.

Also, newer kernels apparently have updates which are relevant to EB MPCore.
-- 
Stefan Richter
-=====-=-=== =--- =--=-
http://arcgraph.de/sr/
