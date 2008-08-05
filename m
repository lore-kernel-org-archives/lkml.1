Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbYHESl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbYHESl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbYHESlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:41:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbYHESlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:41:17 -0400
Date: Tue, 5 Aug 2008 11:38:45 -0700
From: Greg KH <greg@kroah.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interfaceforon access scanning
Message-ID: <20080805183845.GA11375@kroah.com>
References: <20080805112747.2c3c4650@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

On Tue, Aug 05, 2008 at 02:34:26PM -0400, Press, Jonathan wrote:
> You're right...I am not talking about blocking at all -- which may be a
> further indication that I am missing the specific point of this thread.
> 
> But be that as it may...  I don't want to have to use more than one
> interface to get all the events I am interested in.  I want to register
> as a client and listen, and get everything I need from the same place.

That's an implementation issue, not a requirement.  If it's a
requirement, it sure is a lazy one :)

> Also, it seems to me that for my purposes, close is discrete enough.  It
> tells me that there is now something out there that should be looked at.

So, if you hook glibc to catch all calls to close, is that sufficient?

thanks,

greg k-h
