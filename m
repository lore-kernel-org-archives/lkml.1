Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZAIMCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZAIMCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZAIMCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:02:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZAIMCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:02:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: list freezer as supported
Date: Fri, 9 Jan 2009 13:02:11 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20090109093934.GA2857@elf.ucw.cz>
In-Reply-To: <20090109093934.GA2857@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091302.11498.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2009, Pavel Machek wrote:
> Hi!
> 
> Now that people are using freezer for non-suspend/hibernation stuff,
> perhaps it should have separate maintainers entry so that it is easier
> to find?
> 
> What about something like this?

Agreed.

Thanks,
Rafael


> diff --git a/MAINTAINERS b/MAINTAINERS
> index ce6e9a4..65b494f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1809,6 +1809,14 @@ M:	hch@infradead.org
>  W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
>  S:	Maintained
>  
> +FREEZER
> +P:	Pavel Machek
> +M:	pavel@suse.cz
> +P:	Rafael J. Wysocki
> +M:	rjw@sisk.pl
> +L:	linux-pm@lists.linux-foundation.org
> +S:	Supported
> +
>  FTRACE
>  P:	Steven Rostedt
>  M:	rostedt@goodmis.org
> 


-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
