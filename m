Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZCaGBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZCaGBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZCaGBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:01:34 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:46546 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378AbZCaGBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:01:34 -0400
Message-ID: <49D1B1C4.60802@lougher.demon.co.uk>
Date: Tue, 31 Mar 2009 07:01:40 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: squashfs-devel@lists.sourceforge.net,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [Squashfs-devel] Squashfs 4.0 tools
References: <20090323180808.2c2ef1a7@nehalam>	<49C847C6.4030904@lougher.demon.co.uk> <49C86C76.70006@msgid.tls.msk.ru>
In-Reply-To: <49C86C76.70006@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Phillip Lougher wrote:
>> Stephen Hemminger wrote:
>>> It is great that squashfs is finally in mainline kernel. But the
>>> squashfs tools are tightly bound to the version of the squashfs 
>>> filesystem.
> []
>> I have been working on the 4.0 squashfs tools for the last couple of
>> months making them (mksquashfs and unsquashfs) ready for a supported
>> release.  Now that Linux 2.6.29 has been released (3 hours ago), I
>> need to make this release ASAP, which as everything is almost finished,
>> should be sometime this week.
> 
> By the way, with this on-disk format change, is there a way to get
> 4.0 fs code working with 2.6.27 (long-time-stable) kernel?  
I tried  to compile it on 2.6.27 but it fails due to some API changes and I'm
> not that deep into kernel to fix it...
> 

Yes I know.  The 4.0 patches only work on 2.6.28 or later AFAIK.

When I get time and if there's demand (you're the first person to ask
and so there's obviously some demand), I'll backport the patches
to earlier kernels.

Phillip
