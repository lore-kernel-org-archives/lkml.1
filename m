Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZGBL7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZGBL7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZGBL7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:59:38 -0400
Received: from mail.anarazel.de ([217.115.131.40]:47384 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbZGBL7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:59:37 -0400
Message-ID: <4A4CA128.4030906@anarazel.de>
Date: Thu, 02 Jul 2009 13:59:36 +0200
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090629 Shredder/3.0b3pre
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly	caused
 by netem)
References: <4A4A9DD6.8060800@anarazel.de> <4A4BAD5F.7050908@gmail.com> <4A4BD384.3090407@anarazel.de> <4A4C0144.5070203@anarazel.de> <20090702093031.GC4954@ff.dom.local> <20090702101207.GA7056@ff.dom.local> <4A4C95FC.7040305@anarazel.de> <4A4C9D75.5010300@anarazel.de> <20090702115453.GC7402@ff.dom.local>
In-Reply-To: <20090702115453.GC7402@ff.dom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2009 01:54 PM, Jarek Poplawski wrote:
> On Thu, Jul 02, 2009 at 01:43:49PM +0200, Andres Freund wrote: ...
>> I will start trying to place the issue by testing with existing
>> kernels between 2.6.30 and now.
> If you can afford your time of course this would be very helpful.
Well. Waiting for the issue to resolve itself would cost time as well ;-)
I wont be able to finish this today, but perhaps some reduction of the 
search space will be enough.

I placed it between 2.6.30 and 03347e2592078a90df818670fddf97a33eec70fb
(v2.6.30-5415-g03347e2) so far.


Andres
