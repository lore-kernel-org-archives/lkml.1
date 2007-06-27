Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbXF0Vi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbXF0Vi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXF0ViS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:38:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32876 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751752AbXF0ViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:38:17 -0400
Date: Wed, 27 Jun 2007 14:38:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: Andrew Morton <akpm@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
In-Reply-To: <4682A9B6.8070003@google.com>
Message-ID: <Pine.LNX.4.64.0706271437410.31227@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
 <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
 <468023CA.2090401@google.com> <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
 <20070626152204.b6b4bc3f.akpm@google.com> <4682A9B6.8070003@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Ethan Solomita wrote:

> 	I looked over it at one point. Most of the code doesn't conflict, but I
> believe that the code path which calculates the dirty limits will need
> some merging. Doable but non-trivial.
> 	-- Ethan

I hope you will keep on updating the patchset and posting it against 
current mm?

