Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYEWLT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYEWLT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYEWLTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:19:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34489 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753164AbYEWLTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:19:22 -0400
Date: Fri, 23 May 2008 12:06:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Switch apm to unlocked_kernel
Message-ID: <20080523120617.6a4c115c@core>
In-Reply-To: <20080523110353.7a1360b5.sfr@canb.auug.org.au>
References: <20080522212204.177410b8@core>
	<20080523110353.7a1360b5.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 11:03:53 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alan,
> 
> On Thu, 22 May 2008 21:22:04 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > This pushes the lock a fair way down and the final kill looks like it
> > should be an easy project for someone who wants to have a shot at it.
> 
> and makes some gratuitous stylistic changes as well.  Please don't do
> that!

Andrew shouts at me if I send him patches that don't fix the style of
the lines around so you get some style changes even when I cut bits out
of diffs. I think that approach is *stupid* too and style should be done
after for the entire file.

Alan
