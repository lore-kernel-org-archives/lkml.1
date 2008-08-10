Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYHJFsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYHJFsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 01:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYHJFse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 01:48:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYHJFsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 01:48:33 -0400
Message-ID: <489E7F9C.9000708@zytor.com>
Date: Sat, 09 Aug 2008 22:41:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>,
       austin zhang <austin_zhang@linux.intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem
 with fpu state changes
References: <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809003829.GA25926@gondor.apana.org.au> <20080809142918.GA30387@gondor.apana.org.au> <20080809143259.GA30451@gondor.apana.org.au> <20080809175247.GD13158@linux-os.sc.intel.com> <20080810053048.GA3171@gondor.apana.org.au>
In-Reply-To: <20080810053048.GA3171@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Sat, Aug 09, 2008 at 10:52:48AM -0700, Suresh Siddha wrote:
>>> Actually I was mistaken, Intel has done the right thing by not
>>> generating a fault on crc32c with TS set.
>> Yes, the documentation seems to says so. But I am double checking
>> with experts inside, to make sure we got the SDM right.
> 
> Thanks for checking this!

Indeed :)

	-hpa
