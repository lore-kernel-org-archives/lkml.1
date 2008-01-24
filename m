Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYAXRZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYAXRZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYAXRZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:25:47 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53248 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYAXRZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:25:47 -0500
Date: Thu, 24 Jan 2008 19:24:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <davidn@davidnewall.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080124172414.GD4476@does.not.exist>
References: <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4798C511.8070305@davidnewall.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 03:34:17AM +1030, David Newall wrote:
> Adrian Bunk wrote:
> > But Linux kernel development is not driven by people producing hot air 
> > about what they wish to see in the future, Linux kernel development is 
> > driven by people sending patches.
> 
> Removal of code is not development.  It's the opposite of development.

Removing dead code makes:
- the kernel smaller,
- the kernel faster and
- makes it easier to maintain the non-dead code.

All of these are considered useful by the people who actually 
contribute to the Linux kernel.

> At one stage iBCS2 support DID work.  Now it doesn't.  Now there's an
> argument that the remaining infrastructure should be removed.  This is
> the wrong direction to take.

When did iBCS2 support work in a plain ftp.kernel.org kernel?

And if you consider iBCS2 support that important I can only repeat that 
the language on Linux kernel are patches, not hot air.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

