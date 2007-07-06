Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbXGFScx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbXGFScx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760891AbXGFScq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:32:46 -0400
Received: from mx.treblig.org ([80.68.94.177]:3277 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615AbXGFScp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:32:45 -0400
Date: Fri, 6 Jul 2007 19:32:44 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can entire drivers/acorn subdirectory be removed?
Message-ID: <20070706183244.GB25207@gallifrey>
References: <Pine.LNX.4.64.0707060632330.12604@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707060632330.12604@localhost.localdomain>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 19:29:19 up 63 days, 12:12,  1 user,  load average: 0.76, 0.79, 0.66
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert P. J. Day (rpjday@mindspring.com) wrote:

>   and if that happens, then the config variables defined in
> drivers/acorn/block/Kconfig:
> 
>   config BLK_DEV_FD1772
>   config BLK_DEV_MFM
>   config BLK_DEV_MFM_AUTODETECT
> 
> would also vanish, which suggests that any references to *them* could
> also be deleted:

Ah those are blasts from the past; I've got to wonder how many
MFM drives that still work are out there.

I should take the 5.25" FH 64MB drive I tested that on to the tip
sometime.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
