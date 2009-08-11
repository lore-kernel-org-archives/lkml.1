Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZHKRHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZHKRHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 13:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZHKRHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 13:07:31 -0400
Received: from kroah.org ([198.145.64.141]:34731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZHKRHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 13:07:31 -0400
Date: Tue, 11 Aug 2009 09:51:33 -0700
From: Greg KH <greg@kroah.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Al Boldi <a1426z@gawab.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090811165133.GA25937@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <200908110648.26191.a1426z@gawab.com>
 <20090811040431.GA1178@kroah.com>
 <200908111818.16399.a1426z@gawab.com>
 <20090811154931.GA25079@kroah.com>
 <4A81969B.4000601@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A81969B.4000601@nortel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 10:04:43AM -0600, Chris Friesen wrote:
> Greg KH wrote:
> 
> > Again, I don't really believe that you use a CONFIG_HOTPLUG=n system in
> > the real world, so barring a patch from you or anyone else, I'll leave
> > it as-is.
> 
> That seems a bit harsh.  There are lots of embedded devices that don't
> need hotplug.

You seem to have missed the previous statements from Al about this topic
which resulted in him ignoring my previous questions about this topic,
and hence, this statement from me.

And yes, of course I know that embedded devices don't need hotplug, but
again, most of them that support any kind of external device being
plugged into them, use that option.

thanks,

greg "context is everything" k-h
