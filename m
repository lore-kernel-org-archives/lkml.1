Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZAXHli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZAXHli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 02:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZAXHl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 02:41:29 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:44624 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZAXHl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 02:41:29 -0500
Date: Sat, 24 Jan 2009 08:43:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       reiserfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: usr/include/linux/reiserfs_fs.h is having lot of KERNEL data
Message-ID: <20090124074313.GA31882@uranus.ravnborg.org>
References: <1232465242.3088.25.camel@localhost.localdomain> <1232778934.10414.4.camel@localhost.localdomain> <20090124073236.GA6166@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090124073236.GA6166@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > -/* debug levels.  Right now, CONFIG_REISERFS_CHECK means print all debug
> > -** messages.
> > -*/
> > +/* debug levels.  Right now, REISERFS_CHECK means print all debug messages */
> 
> Whoa, fix the tool!

This comment does not make sense in userspace so the tool was right - no?

	Sam
