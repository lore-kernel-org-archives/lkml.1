Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYBJKev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYBJKev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYBJKem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:34:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbYBJKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:34:41 -0500
Date: Sun, 10 Feb 2008 02:31:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm <linux-mm@kvack.org>,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH 2.6.24-mm1]  Mempolicy:  silently restrict nodemask to
 allowed nodes V3
Message-Id: <20080210023142.a217cfbe.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802092340400.2896@woody.linux-foundation.org>
References: <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1202499913.5346.60.camel@localhost>
	<20080210141154.25E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080210054953.GA10371@kroah.com>
	<alpine.LFD.1.00.0802092340400.2896@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 23:42:21 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 9 Feb 2008, Greg KH wrote:
> > 
> > Once the patch goes into Linus's tree, feel free to send it to the
> > stable@kernel.org address so that we can include it in the 2.6.24.x
> > tree.
> 
> I've been ignoring the patches because they say "PATCH 2.6.24-mm1", and so 
> I simply don't know whether it's supposed to go into *my* kernel or just 
> -mm.
> 
> There's also been several versions and discussions, so I'd really like to 
> have somebody send me a final patch with all the acks etc.. One that is 
> clearly for me, not for -mm.
> 

fyi, I won't be able to do much patch-wrangling until Tuesday or Wednesday.
All the big machines are disconnected and mothballed due to domestic
s/carpet/hardwood/g.

