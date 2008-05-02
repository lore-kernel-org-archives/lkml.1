Return-Path: <linux-kernel-owner+w=401wt.eu-S937194AbYEBWoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937194AbYEBWoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbYEBWoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:44:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758278AbYEBWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:44:12 -0400
Date: Fri, 2 May 2008 15:42:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-next@vger.kernel.org, sfrench@us.ibm.com, swhiteho@redhat.com,
       stefanr@s5r6.in-berlin.de, jeff@garzik.org, ralf@linux-mips.org,
       drzeus-list@drzeus.cx, jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com,
       ericvh@gmail.com, wim@iguana.be, chris@zankel.net, nico@cam.org,
       penberg@cs.helsinki.fi, clameter@sgi.com, ezk@cs.sunysb.edu,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080502154200.a6d8c43a.akpm@linux-foundation.org>
In-Reply-To: <20080502151206.b40f77ea.akpm@linux-foundation.org>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 15:12:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The first
> problem is working out "how the heck did that patch get into linux-next"? 
> That would be much easier if the signoff trail was complete for git-based
> patches, but it often is not.

doh.  I'm pulling linux-next's constituent trees independently, so if I
spot a turd in linux-next I can just grep the various git trees to find out
where it came from.

It seems wrong though...
