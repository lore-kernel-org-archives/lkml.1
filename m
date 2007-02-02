Return-Path: <linux-kernel-owner+w=401wt.eu-S1422781AbXBBEE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422781AbXBBEE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXBBEE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:04:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59683 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422781AbXBBEE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:04:28 -0500
Date: Thu, 1 Feb 2007 20:03:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ethan Solomita <solo@google.com>, akpm@linux-foundation.org,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
Message-Id: <20070201200358.89dd2991.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
	<45C2960B.9070907@google.com>
	<Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 18:16:05 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 1 Feb 2007, Ethan Solomita wrote:
> 
> >    Hi Christoph -- has anything come of resolving the NFS / OOM concerns that
> > Andrew Morton expressed concerning the patch? I'd be happy to see some
> > progress on getting this patch (i.e. the one you posted on 1/23) through.
> 
> Peter Zilkstra addressed the NFS issue.

Did he?  Are you yet in a position to confirm that?

