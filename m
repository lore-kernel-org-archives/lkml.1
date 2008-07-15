Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbYGOSOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbYGOSOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbYGOSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:14:20 -0400
Received: from relais.videotron.ca ([24.201.245.36]:21190 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYGOSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:14:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 15 Jul 2008 14:14:18 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Buesch <mb@bu3sch.de>,
       =?ISO-8859-15?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
In-reply-to: <1216144711.13411.18.camel@localhost.localdomain>
Message-id: <alpine.LFD.1.10.0807151404530.12484@xanadu.home>
References: <20080709190915.GA8238@tuxdriver.com>
 <69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
 <200807101815.27204.mb@bu3sch.de>
 <1216142191.6039.113.camel@localhost.localdomain>
 <alpine.LFD.1.10.0807151323570.12484@xanadu.home>
 <1216144711.13411.18.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Dan Williams wrote:

> Some of the issues with the current Marvell 83xx GPL drivers that have
> gotten out are (a) code style, (b) lots of commented out stuff that's
> never used, (c) OS abstraction that's unnecessary on Linux, (d) doesn't
> use mac80211, and (e) uses private ioctls.  So hopefully you're writing
> a new 83xx driver from scratch :)

Yes, this is all from scratch.  The objective for this work is to be 
"mainlinable".

> We cleaned up a lot of stuff for the OLPC 8388 libertas driver, but
> unfortunately we never were able to get the Marvell 8388 team onboard,
> and so they just went off and kept working on their driver and didn't
> really move the upstream libertas driver forward at all.

Libertas is a rather different beast.


Nicolas
