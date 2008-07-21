Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYGUO0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYGUO0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYGUOZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:25:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYGUOZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:25:51 -0400
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
From: Dan Williams <dcbw@redhat.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Michael Buesch <mb@bu3sch.de>,
       Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807151404530.12484@xanadu.home>
References: <20080709190915.GA8238@tuxdriver.com>
	 <69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
	 <200807101815.27204.mb@bu3sch.de>
	 <1216142191.6039.113.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0807151323570.12484@xanadu.home>
	 <1216144711.13411.18.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0807151404530.12484@xanadu.home>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 10:23:44 -0400
Message-Id: <1216650224.22055.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 14:14 -0400, Nicolas Pitre wrote:
> On Tue, 15 Jul 2008, Dan Williams wrote:
> 
> > Some of the issues with the current Marvell 83xx GPL drivers that have
> > gotten out are (a) code style, (b) lots of commented out stuff that's
> > never used, (c) OS abstraction that's unnecessary on Linux, (d) doesn't
> > use mac80211, and (e) uses private ioctls.  So hopefully you're writing
> > a new 83xx driver from scratch :)
> 
> Yes, this is all from scratch.  The objective for this work is to be 
> "mainlinable".

BTW, any chance on putting up a git repo somewhere so others can poke
around with it?  I'm quite interested in hacking on it.

Dan

