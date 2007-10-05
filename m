Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbXJEVHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbXJEVHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbXJEVHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:07:00 -0400
Received: from twin.jikos.cz ([213.151.79.26]:32954 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbXJEVG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:06:59 -0400
Date: Fri, 5 Oct 2007 23:06:55 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: video resume stuff
In-Reply-To: <47068398.9070304@zytor.com>
Message-ID: <Pine.LNX.4.64.0710052258260.25413@twin.jikos.cz>
References: <20071004130513.GA16076@elf.ucw.cz> <470511A9.4060705@zytor.com>
 <20071005073238.GA19065@atrey.karlin.mff.cuni.cz>
 <Pine.LNX.4.64.0710051648440.25413@twin.jikos.cz> <47068398.9070304@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, H. Peter Anvin wrote:

> Jiri, what particular video mode are you running in?  In other words, 
> what is your vga= parameter set to?  In fact, what does your entire 
> kernel command line look like?

Hi,

the videomode is standard 80x25 VGA.

The kernel commandline is 

	root=/dev/sda2 vga=normal 3 acpi_sleep=s3_bios,s3_mode

> Also, if you could extract the information requested in:
> http://marc.info/?i=46FD802D.2030804@zytor.com
> ... that would really help.

bootparams.bin can be found at 
http://www.jikos.cz/jikos/junk/bootparams.bin

Thanks,

-- 
Jiri Kosina
