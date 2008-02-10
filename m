Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYBJFpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYBJFpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 00:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYBJFpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 00:45:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38969 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYBJFpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 00:45:46 -0500
Date: Sat, 9 Feb 2008 21:49:53 -0800
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>, torvalds@linux-foundation.org,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH 2.6.24-mm1]  Mempolicy:  silently restrict nodemask to
	allowed nodes V3
Message-ID: <20080210054953.GA10371@kroah.com>
References: <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1202499913.5346.60.camel@localhost> <20080210141154.25E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210141154.25E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 02:29:24PM +0900, KOSAKI Motohiro wrote:
> CC'd Greg KH <greg@kroah.com>
> 
> I tested this patch on fujitsu memoryless node.
> (2.6.24 + silently-restrict-nodemask-to-allowed-nodes-V3 insted 2.6.24-mm1)
> it seems works good.
> 
> Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> 
> Greg, I hope this patch merge to 2.6.24.x stable tree because
> this patch is regression fixed patch.
> Please tell me what do i doing for it.

Once the patch goes into Linus's tree, feel free to send it to the
stable@kernel.org address so that we can include it in the 2.6.24.x
tree.

thanks,

greg k-h
