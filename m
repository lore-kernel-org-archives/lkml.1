Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYI2AKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYI2AKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 20:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYI2AJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 20:09:59 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:57316 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYI2AJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 20:09:59 -0400
Message-ID: <58677.166.70.238.43.1222644857.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080928194616.10d25760@bree.surriel.com>
References: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com>
    <20080928194536.GC8711@mit.edu>
    <20080928194616.10d25760@bree.surriel.com>
Date: Sun, 28 Sep 2008 17:34:17 -0600 (MDT)
Subject: Re: [REQUEST] Clarification from Copyright Holders on 
     FUSE/NDISWRAPPER
From: jmerkey@wolfmountaingroup.com
To: "Rik van Riel" <riel@redhat.com>
Cc: "Theodore Tso" <tytso@mit.edu>, jmerkey@wolfmountaingroup.com,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 28 Sep 2008 15:45:36 -0400
> Theodore Tso <tytso@mit.edu> wrote:
>
>> The position statement on closed-source Linux Kernel Modules was
>> deliberately not a "policy statement", nor did it talk about issues
>> about what is or isn't legal.  This was deliberate.  Issues over
>> whether or not the GPL covers binary modules fundamentally depend on
>> individual legal jurisdictions' interpretations of copyright law and
>> derivitive works,
>
> This, of course, means you may want to ask your lawyer to
> make sure to which countries binary only kernel modules can
> be distributed and in which countries they are definately
> illegal.
>
> Then you can put some access control in place on your web
> site to make sure people from countries where binary only
> kernel modules are illegal cannot download your drivers.
>
> Of course, what to do with the countries where the answer
> to the question is not clear cut is up to you...
>
> Investigating a few hundred jurisdictions could be a fair
> amount of work, but if you want to be absolutely sure there's
> not much else you can do.
>
> --
> All rights reversed.
>

Rik,

I do not distribute anything outside of the US, and nothing I offer as
downloads is binary without sources.  My website at wolfmountaingroup.org
is open source only, and I feel I am doing my part to the OSS empire in
putting out a kernel debugger and a bunch of other stuff for free.

Ad for countries with anally retentive laws about binary drivers, it
sounds like places no one wants to pay for stuff anyway so I doubt any of
my business associates have any interest in distributing in these
jurisdictions.

The other stuff, including file systems is for commercial companies and
it's not on my website, nor do I distribute it.  I ported the proprietary
file systems over to Free BSD over the summer.  Linux had some advantages
because it has better overall driver support for newer hardware, but the
newer desktops on FreeBSD that are out have left Linux in the dust, and
Free BSD has finally started to catch up to Linux.

One nice thing about putting out a kernel debugger is it gives me a unique
view into the numbers and status developers working on Linux -- and it's
shrinking from the download patterns and the types of folks downloading
it.

Linux is pervasive, but based upon my observations, development is
declining and almost non-existent in commercial companies except for a
small handful of companies.  I do not believe that Free BSD or some other
Unix is going to replace Linux, but what I see happening is a loss of
interest in Unix platforms generally.

M$ has won, again, and not because they are better or have better products
(Linux is tons better than Windows and a lot easier to develop on), but
because there still is simply nothing else out there that is better or
competes well in their space.

Jeff







