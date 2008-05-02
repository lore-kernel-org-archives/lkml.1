Return-Path: <linux-kernel-owner+w=401wt.eu-S936610AbYEBWkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936610AbYEBWkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760589AbYEBWj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:39:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758737AbYEBWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:39:58 -0400
Date: Fri, 2 May 2008 15:33:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, sfrench@us.ibm.com, swhiteho@redhat.com,
       stefanr@s5r6.in-berlin.de, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, penberg@cs.helsinki.fi,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080502153301.8b27ac31.akpm@linux-foundation.org>
In-Reply-To: <481B93AA.7040000@garzik.org>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<481B93AA.7040000@garzik.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 18:20:26 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> > (Jeff, git-libata-all is a pretty important one)
> 
> 
> libata-dev.git#NEXT is for linux-next, and libata-dev.git#ALL is for -mm
> 
> Already taken care of.
> 

Oh.  Something seems to have gone wrong then.

Next/Trees has:

libata          git     git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#NEXT

but:

y:/usr/src/25> diffstat patches/linux-next.patch | grep /ata/      
y:/usr/src/25> 

There's nothing there?

(plans for git-jg-misc?)
