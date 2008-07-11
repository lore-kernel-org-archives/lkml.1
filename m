Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYGKXiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYGKXiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYGKXip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:38:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28524 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYGKXio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:38:44 -0400
Date: Fri, 11 Jul 2008 16:37:26 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-next@vger.kernel.org
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
	failure
Message-ID: <20080711233726.GD22577@mail.oracle.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-next@vger.kernel.org
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com> <20080711220740.GC22577@mail.oracle.com> <20080711155238.f3e257b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711155238.f3e257b0.akpm@linux-foundation.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 03:52:38PM -0700, Andrew Morton wrote:
> On Fri, 11 Jul 2008 15:07:40 -0700 Joel Becker <Joel.Becker@oracle.com> wrote:
> 
> > 	Ok, I've merged all this work.  Please check out my configfs-ALL
> > branch and make sure I have everything we've worked on.
> > 
> > http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=configfs-ALL
> > git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL
> 
> Can you please arrange to get this tree into linux-next?

Hey Andrew,
	I still send configfs stuff through ocfs2.git (it's just
easier).  The first half of these changes have been in linux-next for
about three weeks.  We'll be sending the rest there as soon as Louis
verifies I didn't miss anything :-)

Joel

-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
