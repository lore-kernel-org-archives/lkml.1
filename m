Return-Path: <linux-kernel-owner+w=401wt.eu-S936762AbXJTACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936762AbXJTACy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 20:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932232AbXJTACq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 20:02:46 -0400
Received: from tachyon.jukie.net ([205.150.199.214]:42549 "EHLO jukie.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932198AbXJTACp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 20:02:45 -0400
Date: Fri, 19 Oct 2007 20:02:40 -0400
From: Bart Trojanowski <bart@jukie.net>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Avi Kivity <avi@qumranet.com>
Subject: Re: [BUG] 2.6.23.1 host freezes when running kvm
Message-ID: <20071020000240.GX3962@jukie.net>
References: <20071019202019.GW3962@jukie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019202019.GW3962@jukie.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Bart Trojanowski <bart@jukie.net> [071019 17:00]:
<snip>
> 
> Once the system is booted, I attached using vnc, then I ssh in and ran
> 'svn update'... and the host machine froze.
> 
> The last messages I on my serial console are:
> 
> kvm: unhandled rdmsr: 0x417
> kvm: unhandled rdmsr: 0xc0000400
<snip>
> I noticed that linus merged a bunch of KVM changes last week.  I will
> try those out next.

It looks like Linus' tree has the fix already.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
