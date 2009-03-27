Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZC0PKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZC0PKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZC0PJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:09:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44364 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753323AbZC0PJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:09:57 -0400
Date: Fri, 27 Mar 2009 15:08:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327145156.GB24819@srcf.ucam.org>
References: <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090327032301.GN6239@mit.edu>
	<20090327034705.GA16888@srcf.ucam.org>
	<20090327051338.GP6239@mit.edu>
	<20090327055750.GA18065@srcf.ucam.org>
	<20090327062114.GA18290@srcf.ucam.org>
	<20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And if a behaviour is in ext3, then for the vast majority of practical 
> purposes it exists everywere. Users of non-Linux POSIX operating systems 
> are niche. Users of non-ext3 filesystems on Linux are niche.

SuSE for years shipped reiserfs as a default.

> When my grandmother was growing up she had to use an outside toilet. 
> Sometimes the past sucked and we're glad of progress being made.

Not checking for errors is not "progress" its indiscipline aided by
languages and tools that permit it to occur without issuing errors. It's
why software "engineering" is at best approaching early 1950's real
engineering practice ("hey gee we should test this stuff") and has yet to
grow up and get anywhere into the world of real engineering and quality.

Alan
