Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYGUQqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYGUQqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYGUQqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:46:34 -0400
Received: from relais.videotron.ca ([24.201.245.36]:17685 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYGUQqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:46:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 21 Jul 2008 12:46:31 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Buesch <mb@bu3sch.de>,
       =?ISO-8859-15?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
In-reply-to: <1216650224.22055.7.camel@localhost.localdomain>
Message-id: <alpine.LFD.1.10.0807211245020.3213@xanadu.home>
References: <20080709190915.GA8238@tuxdriver.com>
 <69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
 <200807101815.27204.mb@bu3sch.de>
 <1216142191.6039.113.camel@localhost.localdomain>
 <alpine.LFD.1.10.0807151323570.12484@xanadu.home>
 <1216144711.13411.18.camel@localhost.localdomain>
 <alpine.LFD.1.10.0807151404530.12484@xanadu.home>
 <1216650224.22055.7.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Dan Williams wrote:

> On Tue, 2008-07-15 at 14:14 -0400, Nicolas Pitre wrote:
> > On Tue, 15 Jul 2008, Dan Williams wrote:
> > 
> > > Some of the issues with the current Marvell 83xx GPL drivers that have
> > > gotten out are (a) code style, (b) lots of commented out stuff that's
> > > never used, (c) OS abstraction that's unnecessary on Linux, (d) doesn't
> > > use mac80211, and (e) uses private ioctls.  So hopefully you're writing
> > > a new 83xx driver from scratch :)
> > 
> > Yes, this is all from scratch.  The objective for this work is to be 
> > "mainlinable".
> 
> BTW, any chance on putting up a git repo somewhere so others can poke
> around with it?  I'm quite interested in hacking on it.

Eventually, of course.  Let's discuss f2f tomorrow.


Nicolas
