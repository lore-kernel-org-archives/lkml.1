Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYKIFze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYKIFze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 00:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYKIFzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 00:55:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbYKIFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 00:55:23 -0500
Date: Sat, 8 Nov 2008 21:54:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
Message-Id: <20081108215458.1799896b.akpm@linux-foundation.org>
In-Reply-To: <200811081412.21736.rjw@sisk.pl>
References: <200811081353.34442.rjw@sisk.pl>
	<20081108125952.GB21405@elf.ucw.cz>
	<200811081412.21736.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Nov 2008 14:12:21 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday, 8 of November 2008, Pavel Machek wrote:
> > Hi!
> > 
> > > This would be good to have in .28 IMO.
> > 
> > Actually, this makes sense even for .27-stable, AFAICT.
> 
> Yes, it does, but it has to be merged first. :-)

It applies to 2.6.26 (at least).  Is there no need for it in kernels
earlier than 2.6.27.x?
