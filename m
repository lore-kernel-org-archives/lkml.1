Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbXBFL24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbXBFL24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXBFL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:28:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36184 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053AbXBFL2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:28:55 -0500
Date: Tue, 6 Feb 2007 11:41:52 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][0/5] floppy.c: first round of cleanup patches - the
 simple stuff
Message-ID: <20070206114152.4b622e40@localhost.localdomain>
In-Reply-To: <200702060028.31691.jesper.juhl@gmail.com>
References: <200702060028.31691.jesper.juhl@gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 00:28:31 +0100
Jesper Juhl <jesper.juhl@gmail.com> wrote:

> Greetings people,
> 
> Here is, as promised, the first round of cleanup patches for floppy.c
> (more will follow later).
> 
> I opted to start with the simple stuff first, both to get it out of the way
> and also to get something done resonably fast, so don't expect anything 
> earth shattering in this first series.
> 
> There are 5 patches in this series. They are based on 2.6.20 and are
> incremental.
> 
> These are the patches (they'll be posted to the same recipients as this initial mail) : 
> 
> 	[PATCH][1/5] floppy.c: Initial (partial) CodingStyle cleanup
> 	[PATCH][2/5] floppy.c: Remove pointless register keywords
> 	[PATCH][3/5] floppy.c: Remove dead/commented out code
> 	[PATCH][4/5] floppy.c: Add explicit/better printk() levels
> 	[PATCH][5/5] floppy.c: Fix device_create_file() warning

Acked-by: Alan Cox <alan@redhat.com>

for the set of 5 patches. Its a beginning and removing the dead wood so
you can see what is actually there is a good a beginning as any other.

