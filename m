Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXFUDcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXFUDcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXFUDcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:32:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXFUDce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:32:34 -0400
Message-ID: <4679F14F.9050008@zytor.com>
Date: Wed, 20 Jun 2007 20:32:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: JIT emulator needs
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>	 <20070619150824.GH11781@holomorphy.com>	 <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>	 <20070620160116.GI6909@holomorphy.com> <467957CB.8020704@zytor.com>	 <787b0d920706201125g2368a4e1i2d115b0b2d5399e5@mail.gmail.com>	 <46797747.9020904@zytor.com> <787b0d920706202021t567b2fefu869a03ef76f245da@mail.gmail.com>
In-Reply-To: <787b0d920706202021t567b2fefu869a03ef76f245da@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
>>
>> That's fine.  That's a policy decision.  That's what a security policy
>> *is*.  The owner of the system has decided, by security policy, that
>> that is not allowed.  Bypassing that is not acceptable.
> 
> Fixing a bug should be acceptable.
> 

That's not what you're trying to do, though.  You're trying to change
the behaviour underneath the security policy.  If there is a bug, it's
in the security policy and that's where it needs to be changed.

> Look, let's back up a bit here. At a high level, what exactly do
> you imagine that this behavior was intended for? I suggest you
> list some examples of the attacks that are blocked.
> 
> Can you come up with a reasonable argument that the current behavior
> is the least painful restriction required to block those attacks?
> Does the current behavior block any attack that the proposed behavior
> would not? (list the attacks please)

See above.

	-hpa
