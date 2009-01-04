Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbZADA2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbZADA2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZADA2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:28:43 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45418 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZADA2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:28:43 -0500
Date: Sun, 4 Jan 2009 01:28:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Gabor MICSKO <gmicsko@gmail.com>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Grsecurity is about to be discontinued, unless...
In-Reply-To: <1231013176.6497.20.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0901040125190.2418@twin.jikos.cz>
References: <1231013176.6497.20.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jan 2009, Gabor MICSKO wrote:

> In short, I would like to know what is your answer to this request. And 
> in the case if you see no chance for the integration, I would like to 
> know what is the reason behind this decision.

I think that the main question here is -- what exact features are you 
missing in the vanilla Linux kernel that grsecurity provides?

Over past months/years, vanilla kernel gained some of the features that 
were initially present only in the PaX/grsecurity patchsets (address space 
layout randomization for x86, to name the one that I have been involved 
in myself).
Other things (roles? && access control stuff ) could be achieved by code 
that is already present in the vanilla kernel (selinux, smack and 
friends).

Thanks,

-- 
Jiri Kosina
SUSE Labs

