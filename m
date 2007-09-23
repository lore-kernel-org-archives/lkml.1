Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbXIWSgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbXIWSgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbXIWSgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:36:09 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49540 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbXIWSgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:36:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=WwQsDSN//VOxQ4+TmnMqbw7nY3cWO19iSNBfb+GqazXdZou/nKFuFEwx7BneINFzaKSff6AldGU8mYWD/Pm1rrbNdtLluQFJlnLRtZP8i0DJBQjF0u34IspiT7xJ7b5z;
Message-ID: <46F6B215.3050500@simon.arlott.org.uk>
Date: Sun, 23 Sep 2007 19:36:05 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/3] cxacru: Cleanup code by removing "ret = ret;" assignments
References: <46F68708.6070409@simon.arlott.org.uk> <46F687E8.3010101@simon.arlott.org.uk> <200709231820.33086.duncan.sands@math.u-psud.fr>
In-Reply-To: <200709231820.33086.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/07 17:20, Duncan Sands wrote:
> On Sunday 23 September 2007 17:36:08 Simon Arlott wrote:
>> Cleanup code by removing "ret = ret;" assignments.
>> 
>> Signed-Off-By: Simon Arlott <simon@fire.lp0.eu>
> 
> Acked-by: Duncan Sands <baldrick@free.fr>

Nacked-by: Simon Arlott <simon@fire.lp0.eu>

I'm only going to create a merge conflict with myself with this :|
It'll be included with 1/3 shortly.

-- 
Simon Arlott
