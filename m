Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbXFDTwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbXFDTwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbXFDTwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:52:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37954 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758049AbXFDTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:52:13 -0400
Date: Mon, 4 Jun 2007 12:52:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
In-Reply-To: <46646A33.6090107@google.com>
Message-ID: <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
 <46646A33.6090107@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Ethan Solomita wrote:

> > You should preserve my Signed-off-by: since I wrote most of this. Is there 
> > a changelog?
> > 
> 
> 	I wasn't sure of the etiquette -- I'd thought that by saying you had
> signed it off that meant you were accepting my modifications, and didn't
> want to presume. But I will change it if you like. No slight intended.
> 
> 	Unfortunately I don't have a changelog, and since I've since forward
> ported the changes it would be hard to produce. If you want to review it
> you should probably review it all, because the forward porting may have
> introduced issues.

I glanced over it and it looks okay. Please cc me on future submissions.

What testing was done? Would you include the results of tests in your next 
post?



