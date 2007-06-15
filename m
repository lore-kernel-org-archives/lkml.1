Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbXFOQc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbXFOQc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXFOQcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:32:47 -0400
Received: from [212.112.238.170] ([212.112.238.170]:57313 "EHLO
	longford.lazybastard.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbXFOQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:32:47 -0400
Date: Fri, 15 Jun 2007 18:27:56 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070615162756.GB7747@lazybastard.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org> <20070614182201.GD31984@lazybastard.org> <20070614202047.GD1928@DervishD> <20070614204345.GH31984@lazybastard.org> <20070615162001.GC2373@DervishD>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070615162001.GC2373@DervishD>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 June 2007 18:20:01 +0200, DervishD wrote:
> 
> > >     Now seriously, I will take a look at LogFS from time to time, and if
> > > you want me to, I can do tests on my Kingston DT.
> > 
> > That would be appreciated.  I am always happy about bug reports.  The
> > more you test the faster I can fix things.
> 
>     I'm going to upgrade to 2.6.20.x next week, probably, but I'm not
> fully sure. Can your patch be applied to 2.6.19.5 or different versions
> are needed for each and every latest kernel release? I've seen the code
> in your web and looked like it will work in any 2.6.x kernel as long as
> it is not very old, am I wrong?.

It should, I just haven't tested it.  Same for the I_SYNC patch.

>     If it can be used with 2.6.19.5, I can test ASAP even if I don't
> upgrade to 2.6.20.x. I cannot reboot my machine until Monday (except if
> a power shortage does the job for me, of course), but then I'll patch my
> kernel and test LogFS. I'm impatient!

Just try the patches.  If both apply without rejects, things should be
fine.  Otherwise I'll have to take a look.

Jörn

-- 
The competent programmer is fully aware of the strictly limited size of
his own skull; therefore he approaches the programming task in full
humility, and among other things he avoids clever tricks like the plague.
-- Edsger W. Dijkstra
