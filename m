Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZC0TCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZC0TCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZC0TCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:02:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39117 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752824AbZC0TCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:02:24 -0400
Date: Fri, 27 Mar 2009 19:00:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327190056.3b699e89@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903271138220.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu>
	<20090327055750.GA18065@srcf.ucam.org>
	<20090327062114.GA18290@srcf.ucam.org>
	<20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
	<20090327161553.31436545@lxorguk.ukuu.org.uk>
	<20090327162841.GA26860@srcf.ucam.org>
	<20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	<20090327170208.GA27646@srcf.ucam.org>
	<alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
	<20090327183214.2e73b6a3@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0903271138220.3994@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Far too many people don't - and it is unfortunate but people should learn
> > to write quality software.
> 
> You're ignoring reality.
> 
> Your definition of "quality software" is PURE SH*T.

Actually "pure sh*t" is most of the software currently written. The more
code I read the happier I get that the lawmakers are finally sick of it
and going to make damned sure software is subject to liability law. Boy
will that improve things.

> Alan, just please face that reality, and think about it for a moment. If 
> fsync() was instantaneous, this discussion wouldn't exist. But read the 
> thread. We're talking 3-5s under NORMAL load, with peaks of minutes.

The peaks of minutes is a bug. The 3-5 seconds is the thread discussion.

Alan
