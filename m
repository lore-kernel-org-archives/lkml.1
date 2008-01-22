Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYAVPxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYAVPxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYAVPxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:53:33 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59168 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYAVPxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:53:32 -0500
Date: Tue, 22 Jan 2008 17:52:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <davidn@davidnewall.com>
Cc: Karl Kiniger <karl.kiniger@med.ge.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080122155206.GA23277@does.not.exist>
References: <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122102436.GA15563@wszip-kinigka.euro.med.ge.com> <47960673.3020902@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47960673.3020902@davidnewall.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 01:36:27AM +1030, David Newall wrote:
> Karl Kiniger wrote:
> > on http://www.feise.com/~jfeise/Downloads/linux-abi/
> >
> > a patch named  linux-abi-2.6.22.3_3.diff.bz2 can be found.
> 
> Thankyou for that.
> 
> Matter of interest: if it works, why isn't it in the mainline?

This you have to ask the person offering this patch.

Patches don't enter the kernel by themselves, someone has to submit 
them.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

