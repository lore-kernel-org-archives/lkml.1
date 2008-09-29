Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYI2B5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYI2B5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 21:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYI2B5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 21:57:37 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43924 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbYI2B5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 21:57:37 -0400
Date: Sun, 28 Sep 2008 21:57:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: jmerkey@wolfmountaingroup.com
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [REQUEST] Clarification from Copyright Holders on
	FUSE/NDISWRAPPER
Message-ID: <20080929015730.GK8711@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	jmerkey@wolfmountaingroup.com, Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com> <20080928194536.GC8711@mit.edu> <20080928194616.10d25760@bree.surriel.com> <58677.166.70.238.43.1222644857.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58677.166.70.238.43.1222644857.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 05:34:17PM -0600, jmerkey@wolfmountaingroup.com wrote:
> One nice thing about putting out a kernel debugger is it gives me a unique
> view into the numbers and status developers working on Linux -- and it's
> shrinking from the download patterns and the types of folks downloading
> it.

You're assuming that your metrics of people downloading your kernel
debugger is an accurate way of measuring how many people are
developing Linux.

> Linux is pervasive, but based upon my observations, development is
> declining and almost non-existent in commercial companies except for a
> small handful of companies.  I do not believe that Free BSD or some other
> Unix is going to replace Linux, but what I see happening is a loss of
> interest in Unix platforms generally.

You may find these research reports interesting:

http://www.linuxfoundation.org/publications/linuxkerneldevelopment.php
http://www.linux-foundation.org/publications/IDC_Workloads.pdf

The former shows that the development rate is if anything, increasing
based on analyzing the rate that changes are flowing into the Linus's
git tree --- something which I think everyone would agree is a better
way of measuring the rate of development than the number of downloads
of mdb.

The latter is a report from IDC which calculates total enterprise
spending in the Linux ecosystem at $21 billion in 2007, and predicts
that by 2011 the figure will more than double to $49 billion.

So the health of Linux, both in terms of the rate of development and
the enterprise server ecosystem, seems to be doing quite well (never
mind the surge of interest of Linux for mobile platforms).  But if you
want to develop on FreeBSD, hey, don't let us stop you.  Different
licensing strokes for different folks, after all...

Regards,

						- Ted
