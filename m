Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYEaRqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYEaRqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 13:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYEaRqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 13:46:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:36108 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbYEaRp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 13:45:57 -0400
Date: Sat, 31 May 2008 10:43:57 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: via agp patches
Message-ID: <20080531174357.GA18858@suse.de>
References: <20080531003214.GA6208@suse.de> <20080531003354.GC6208@suse.de> <20080531132532.668f6520@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531132532.668f6520@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 01:25:32PM +0100, Alan Cox wrote:
> On Fri, 30 May 2008 17:33:54 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > This looks like the meatiest patch, with lots of support for new
> > hardware.  Gotta love the StudlyCaps...
> 
> > + * Permission is hereby granted, free of charge, to any person
> > + * obtaining a copy of this software and associated documentation
> > + * files (the "Software"), to deal in the Software without
> > + * restriction, including without limitation the rights to use,
> > + * copy, modify, merge, publish, distribute, sub license,
> > + * and/or sell copies of the Software, and to permit persons to
> > + * whom the Software is furnished to do so, subject to the
> > + * following conditions:
> 
> Do we think the above is GPL compatible, do VIA think so, do VIA care to
> say in writing they consider it is if there are questions ?

As Via states in this patch later on:
	MODULE_LICENSE("GPL and additional rights");

Yes, I think it is fair to say it is GPL compatible.  Isn't this just a
variant of the BSD license?

thanks,

greg k-h
