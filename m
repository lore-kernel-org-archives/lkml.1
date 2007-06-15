Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbXFOQT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbXFOQT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXFOQTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:19:47 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:64548 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbXFOQTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:19:46 -0400
Date: Fri, 15 Jun 2007 18:20:01 +0200
From: DervishD <lkml@dervishd.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070615162001.GC2373@DervishD>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org> <20070614182201.GD31984@lazybastard.org> <20070614202047.GD1928@DervishD> <20070614204345.GH31984@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614204345.GH31984@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jörn :)

 * Jörn Engel <joern@logfs.org> dixit:
> On Thu, 14 June 2007 22:20:47 +0200, DervishD wrote:
> >     I'm with you in that. So stop emailing and go working on it XD
> 
> :)

    No. Seriously. Go! XDD
 
> >     Now seriously, I will take a look at LogFS from time to time, and if
> > you want me to, I can do tests on my Kingston DT.
> 
> That would be appreciated.  I am always happy about bug reports.  The
> more you test the faster I can fix things.

    I'm going to upgrade to 2.6.20.x next week, probably, but I'm not
fully sure. Can your patch be applied to 2.6.19.5 or different versions
are needed for each and every latest kernel release? I've seen the code
in your web and looked like it will work in any 2.6.x kernel as long as
it is not very old, am I wrong?.

    If it can be used with 2.6.19.5, I can test ASAP even if I don't
upgrade to 2.6.20.x. I cannot reboot my machine until Monday (except if
a power shortage does the job for me, of course), but then I'll patch my
kernel and test LogFS. I'm impatient!

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
