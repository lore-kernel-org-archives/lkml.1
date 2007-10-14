Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXJNBqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXJNBqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 21:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXJNBqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 21:46:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42983 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbXJNBqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 21:46:37 -0400
Subject: Re: [PATCH] JFS: Bio cleanup: Replace missing return statements
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071013122853.aafd3c00.randy.dunlap@oracle.com>
References: <20071013191110.GA20203@havoc.gtf.org>
	 <20071013122853.aafd3c00.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 20:46:30 -0500
Message-Id: <1192326390.6982.0.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-13 at 12:28 -0700, Randy Dunlap wrote:
> On Sat, 13 Oct 2007 15:11:10 -0400 Jeff Garzik wrote:
> 
> > 
> > From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> > 
> > commit 6712ecf8f648118c3363c142196418f89a510b90 removed some "return 0;"
> > statements, rather than changing them to null returns.
> 
> Is my git tree mucked up?  It looks to me like it was commit
> e30408b2a99cb7b8bf529c7dc2328a19d71894cf  that removed the return 0's.

Yeah.  It was that one.  I cut and pasted the wrong one for the comment.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

