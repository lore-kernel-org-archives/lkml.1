Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbXIAT1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbXIAT1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbXIAT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:27:12 -0400
Received: from mx.treblig.org ([80.68.94.177]:3185 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbXIAT1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:27:12 -0400
Date: Sat, 1 Sep 2007 20:27:04 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
Message-ID: <20070901192704.GA5228@gallifrey>
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey> <20070827214333.GM3118@fieldses.org> <20070828180306.GA25233@gallifrey> <20070828185621.GD3764@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828185621.GD3764@fieldses.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 20:26:29 up 19 days,  3:41,  2 users,  load average: 0.37, 0.48, 0.46
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* J. Bruce Fields (bfields@fieldses.org) wrote:
> On Tue, Aug 28, 2007 at 07:03:06PM +0100, Dr. David Alan Gilbert wrote:

<snip>

> > I'm not going to be able to recut the patch until the weekend;
> > do you just want to remove the 'err' in your copy and feed this
> > to the main tree with some of the rest of your patches?
> 
> Done; result at
> 
> 	git://linux-nfs.org/~bfields/linux.git	nfs-server-stable
> 
> if you'd like to check.

Yep, that's fine.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
