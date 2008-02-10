Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYBJHnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYBJHnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbYBJHnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:43:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbYBJHnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:43:11 -0500
Date: Sat, 9 Feb 2008 23:42:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>, Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH 2.6.24-mm1]  Mempolicy:  silently restrict nodemask to
 allowed nodes V3
In-Reply-To: <20080210054953.GA10371@kroah.com>
Message-ID: <alpine.LFD.1.00.0802092340400.2896@woody.linux-foundation.org>
References: <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1202499913.5346.60.camel@localhost> <20080210141154.25E7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080210054953.GA10371@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Feb 2008, Greg KH wrote:
> 
> Once the patch goes into Linus's tree, feel free to send it to the
> stable@kernel.org address so that we can include it in the 2.6.24.x
> tree.

I've been ignoring the patches because they say "PATCH 2.6.24-mm1", and so 
I simply don't know whether it's supposed to go into *my* kernel or just 
-mm.

There's also been several versions and discussions, so I'd really like to 
have somebody send me a final patch with all the acks etc.. One that is 
clearly for me, not for -mm.

			Linus
