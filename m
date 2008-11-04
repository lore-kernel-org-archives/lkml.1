Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYKDNfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYKDNfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 08:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYKDNe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 08:34:56 -0500
Received: from arrakis.dune.hu ([195.56.146.235]:50981 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYKDNez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:34:55 -0500
X-Spam-Score: -3.304
Date: Tue, 04 Nov 2008 14:34:48 +0100
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Karl Hiramoto" <karl@hiramoto.org>
Subject: Re: IXP4XX Maintainer
From: "Imre Kaloz" <kaloz@openwrt.org>
Organization: OpenWrt - Wireless Freedom
Cc: =?utf-8?Q?Miguel_=C3=81ngel_=C3=81lvarez?= 
	<gotzoncabanes@gmail.com>,
       khc@pm.waw.pl, kernel@wantstofly.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <b0438a630811032237s1a859a46ic6ee423c670720c1@mail.gmail.com>
 <op.uj3ft2yq2s3iss@ecaz> <49103E57.20107@hiramoto.org>
 <20081104123405.GC5241@flint.arm.linux.org.uk>
Content-Transfer-Encoding: 7bit
Message-ID: <op.uj3j0agg2s3iss@ecaz>
In-Reply-To: <20081104123405.GC5241@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 13:34:05 +0100, Russell King - ARM Linux  
<linux@arm.linux.org.uk> wrote:

> On Tue, Nov 04, 2008 at 01:21:43PM +0100, Karl Hiramoto wrote:
>> Imre Kaloz wrote:
>> > I was supposed to pick it up, just Real Life (tm) got in the way..
>> > I'll queue up my pending
>> > patches during this week, and submit them to the arm-kernel list.
>
> That fills me with dread.

No pain, no gain :) You can merge them when you have time - the biggest
problem right now (IMHO) is the lack of central repository for platform
patches - OpenWrt isn't an official one.

>> A lot of the stuff in openwrt svn would be nice to see mainline :-)
>
> I don't have the bandwidth to review this stuff, so the only way
> progress is going to be made is if that's sorted out first.
>
> I've been asking for a maintainer for IXP4xx stuff, and Imre did
> volunteer.  However, if Imre's not able to do so, we need someone
> else to take that job on.
>
> So, can someone from the openwrt community (who seem to be the active
> IXP4xx folk) volunteer to replace Imre?

That's not necessary, things have settled down. I'll submit the NPE patches
to Krysztof as well, so hopefully everything goes mainline really soon.


Imre
