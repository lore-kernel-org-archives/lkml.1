Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbXI3XXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbXI3XXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXI3XXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:23:35 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58127
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXI3XXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:23:34 -0400
Date: Sun, 30 Sep 2007 16:24:00 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Andi Kleen <ak@suse.de>
cc: casey@schaufler-ca.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
In-Reply-To: <200709301934.01442.ak@suse.de>
Message-ID: <alpine.DEB.0.9999.0709301609150.8382@asgard>
References: <984405.24264.qm@web36601.mail.mud.yahoo.com> <200709301934.01442.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007, Andi Kleen wrote:

>> The authentication issues are very real, but a separate issue.
>
> First rule of network security: don't trust the network.

This I agree with

> Without authentication it's completely useless. I don't understand
> how you can disregard that as "separate issue". Security is only
> secure if you plugged all applicable holes; without that it's useless
> and you might as well not bother.

but this is so silly that I have to object.

saying that any security short of perfect security is worthless and we 
shouldn't bother is wrong, and needs to be countered every time it's 
said.

as ted pointed out in response to your other comments, it very much 
depends on where the trust boundry is. so from the point of view of 
absolute security you are wrong.

but even more then that, the vast majority of the time absolute security 
isn't what matters, relative security is what matters (the model of "I 
don't have to outrun the bear, I only have to outrun you") and in these 
envrionments things that are less then absolute can still be very useful.

how useful they are depends on a lot of details, and in the case of the 
network security being discussed it sure sounds like it's pretty close to 
useless if you can't trust the network and the other machines on it, but 
that is seperate from the mentality that "anything less then perfect 
security is worthless and shouldn't be bothered with" which is what I'm 
objecting to.

David Lang
