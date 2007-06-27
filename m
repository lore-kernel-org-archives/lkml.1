Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbXF0KTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbXF0KTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXF0KSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:18:53 -0400
Received: from sqlprd.sybase.co.za ([192.96.139.1]:38217 "EHLO
	cranium.sybase.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757701AbXF0KSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:18:52 -0400
X-Greylist: delayed 1672 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 06:18:50 EDT
From: Alan McKinnon <alan@linuxholdings.co.za>
To: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Date: Wed, 27 Jun 2007 11:54:25 +0200
User-Agent: KMail/1.9.7
References: <200706212349.54983.zoltan.hubert@zzaero.com> <6FD45914-1793-45D5-B0A1-F5D32ED38017@e18.physik.tu-muenchen.de> <200706271118.36985.zoltan.hubert@zzaero.com>
In-Reply-To: <200706271118.36985.zoltan.hubert@zzaero.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706271154.25907.alan@linuxholdings.co.za>
X-OriginalArrivalTime: 27 Jun 2007 09:52:32.0719 (UTC) FILETIME=[E1E025F0:01C7B8A0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007, Zoltán HUBERT wrote:

> If I have to rely on the distribution to help me it spoils
> the whole benefit of open source. I don't trust Novell or
> RedHat or Google more than Microsoft or Apple. You "kernel
> developpers" are the keepers of the flame.

You seem to misunderstand kernel development. You also seem to expect a 
lot from something that is gifted to you gratis.

These nice people at kernel.org have never claimed that they will 
support older kernel versions. What they have said is that the -stable 
team currently publish 2.6.20 and 2.6.21 while Adrian Bunk is doing his 
thing with 2.6.16. As for back-porting new stuff into old kernels, 
that's the distro's job. If you don't trust the distro, then get one 
you do trust. If you trust none of them, then can I suggest you use the 
one resource you *can* trust - yourself?

*That* is the "whole benefit of open source" - you get to do it yourself 
if you choose to/need to

[snip]

> I don't remember how it was during 2.4 and before, but I
> find it very suspicious that SuSE and RedHat only provide
> 2.6.10 and 2.6.9 for their OS. It looks as if THEY didn't
> trust 2.6.x to be a replacement to 2.6.y

No, it means they chose 2.6.whatever for a specific version of their OS 
and they maintain that kernel series to fit that OS.

They also do not take any arb new glibc version and stick that into the 
OS either, because that breaks stuff. But I don't see you complaining 
about that.

> And as I understand it, this is (was ?) the whole point of
> stable/development kernels. "We" can trust a newer stable
> kernel to be a drop-in replacement for an older stable
> kernel (from the same series), while development kernels
> need time to stabilise with the new whizz-bang-pfouit stuff
> that you all so nicely add.

That might have been the case in the 2.4 era, but it's not the case now. 
It changed early on in the 2.6 series and it was changed for very sound 
engineering reasons. Put simply - a stable/dev scenario just didn't 
work and there was way tooo much work for way too little gain.

Distros themselves are the best resource to supply stable kernels, 
because they have been doing that anyway for a long time now.


alan


-- 
Optimists say the glass is half full,
Pessimists say the glass is half empty,
Developers say wtf is the glass twice as big as it needs to be?

Alan McKinnon
alan at linuxholdings dot co dot za
+27 82, double three seven, one nine three five
