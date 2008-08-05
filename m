Return-Path: <linux-kernel-owner+w=401wt.eu-S1764874AbYHEUWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764874AbYHEUWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764557AbYHEUUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:20:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:33907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764488AbYHEUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:20:32 -0400
Date: Tue, 5 Aug 2008 13:18:16 -0700
From: Greg KH <greg@kroah.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080805201816.GD27192@kroah.com>
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 02:38:23PM -0400, Press, Jonathan wrote:
> >> I think you might be missing the point a bit here, as the traditional
> Unix model that 
> >> Linux has prevents much of what the "traditional AV" products need to
> do, right?
> 
> Is your point that Linux and Unix machines are less vulnerable to
> viruses?  If so, that's not relevant to my point at all.  A Unix machine
> can be a carrier, passing infections on to other vulnerable platforms
> (guess which one).

So you are going to try to force us to take something into the Linux
kernel due to the security inadiquacies of a totally different operating
system?  You might want to rethink that argument :)

> An enterprise security system sees the entire enterprise as an
> integrated whole -- not just individual machines with their own
> separate attributes and no impact on each other at all.

I agree, but as others have pointed out, you don't need to do this in
the kernel, you can do it from userspace today (samba has hooks for this
for that "other" operating system already).

thanks,

greg k-h
