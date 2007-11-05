Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXKETOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXKETOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXKETOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:14:24 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43680 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752403AbXKETOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:14:23 -0500
Date: Mon, 5 Nov 2007 20:14:00 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] move edac.txt DOCUMENTATION two levels up
Message-ID: <20071105191400.GB3444@stusta.de>
References: <20071105171733.307a562a@the-village.bc.nu> <293742.55428.qm@web50101.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <293742.55428.qm@web50101.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 10:52:01AM -0800, Doug Thompson wrote:
> Interesting
> 
> At the time I submitted it there was a big discussion on just how messed up the documentation
> directory was, inconsistent and not well laid out. Then more discussion on how it could be laid
> out in relation to where various subsystem were laid out (ie drivers doc directory like there was
> a drivers src directory and the like).
> 
> Therefore I placed it following that pattern.
> 
> So what I am hearing is that documentation for a subsystem should just continue to be dumped into
> one directory with everything else.
> 
> Okay, if that is the goal, I am fine with, but things are pretty jumbled up in there. I will know
> where it is at least.

The current status quo is that everything is in one directory.

If someone wants to put more structure into Documentation/ that would be 
fine with me, but edac.txt being the only file under 
Documentation/drivers/ doesn't make sense and only makes it harder to 
find this file.

> doug t

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

