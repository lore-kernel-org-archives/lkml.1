Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0BGKVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 05:21:22 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:30133 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab0BGKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 05:21:21 -0500
Date: Sun, 7 Feb 2010 02:20:16 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
Message-ID: <20100207102016.GH3416@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>
 <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B6E9417.00E4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 02:49:49PM -0800, Linus Torvalds wrote:
>    Would it be ok to _only_ have the 'bz2' patches and tar-balls?
> 
> Having two copies of every large file seems silly, if nobody really 
> requires the traditional .gz format..

	When I grab tarballs, I only grab .gz.  Bandwidth isn't a
problem (3 minutes versus four on my DSL, I still switch over to another
screen and check back).  But .bz2 unpacks very slowly in the
environments I'm usually grabbing a tarball for.  I save more time
unpacking .gz than I do downloading .bz2.
	That said, I'm often doing repeated unpacks, so I could easily
turn a .bz2 into .gz when I first grab it, then use the local .gz.

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
