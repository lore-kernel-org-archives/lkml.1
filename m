Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbZANUZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbZANUZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZANUZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:25:34 -0500
Received: from vena.lwn.net ([206.168.112.25]:40186 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbZANUZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:25:33 -0500
Date: Wed, 14 Jan 2009 13:25:31 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Greg KH <gregkh@suse.de>
Cc: Wang Chen <wangchen@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Who wrote 2.6.28
Message-ID: <20090114132531.3d4fe013@bike.lwn.net>
In-Reply-To: <20090112040927.GA26742@suse.de>
References: <496224D7.2030109@cn.fujitsu.com>
	<3f9a31f40901090609n29b4e36dwe6fff7fdfc705c7e@mail.gmail.com>
	<20090109.141124.154196743.davem@davemloft.net>
	<20090110213121.GF31579@mit.edu>
	<20090110220004.GA5875@suse.de>
	<496AA506.20900@cn.fujitsu.com>
	<20090112040927.GA26742@suse.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009 20:09:27 -0800
Greg KH <gregkh@suse.de> wrote:

> On Mon, Jan 12, 2009 at 10:03:50AM +0800, Wang Chen wrote:
> > > If you look at the tool that Jon wrote, and the data files that I
> > > keep up to date, this is already handled there.
> > > 
> > > thanks,
> > > 
> > 
> > Greg, I've used your gitdm-config-2.6. And don't see any update,
> > where should I find your latest work?
> 
> No, I haven't, sorry.  I need to push out a new update soon.  Hm,
> gitdm-config?  Did I release that?  If so, where?

OK, for the curious, I've put out an updated version of the gitdm
configuration database:

	http://lwn.net/images/gitdm/gitdm-config-2.6.28.tar.bz2

As always, the current version of gitdm can be pulled from:

	git://git.lwn.net/gitdm.git

It's *still* an ugly hack, but maybe it's slowly getting better...:)

jon
