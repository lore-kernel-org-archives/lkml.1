Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbXGEHFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbXGEHFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 03:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbXGEHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 03:05:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60795 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbXGEHFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 03:05:25 -0400
Date: Thu, 5 Jul 2007 00:04:50 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH -mm 0/9] netconsole: Multiple targets and dynamic reconfigurability
Message-ID: <20070705070450.GI17650@tasint.org>
Mail-Followup-To: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Keiichi KII <k-keiichi@bx.jp.nec.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <468B8952.9030205@bx.jp.nec.com> <Pine.LNX.4.64.0707041752210.29756@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707041752210.29756@cselinux1.cse.iitk.ac.in>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 05:55:15PM +0530, Satyam Sharma wrote:
> On Wed, 4 Jul 2007, Keiichi KII wrote:
> > By the way, how can I add Signed-off-by:'s to your patches?
> > Should I add it to each patch and submit them to this list again?
> > 
> > Anybody could give me an advice?
> 
> I think you could just individually reply to all the mails and replace
> the "Cc:" in front of your name + email ID with "Signed-off-by:" --
> after reviewing & testing this, of course!

	If the chain is not going through Keiichi, he should be
responding with "Acked-by:", not "Signed-off-by:".  Then Satyam submits
the patches upstream with the Acked-by: line and his own Signed-off-by:

Joel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
