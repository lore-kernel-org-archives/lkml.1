Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXA2TR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXA2TR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXA2TR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:17:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51675 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXA2TR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:17:56 -0500
Date: Mon, 29 Jan 2007 11:16:35 -0800
From: Andrew Morton <akpm@osdl.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Thomas@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Greg@maccavity.nachtwache.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo@maccavity.nachtwache.org, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Paul Mackerras <paulus@samba.org>,
       Gleixner <tglx@linutronix.de>, Douglas Niehaus <niehaus@eecs.ku.edu>,
       Molnar <mingo@redhat.com>
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic
 primitives
Message-Id: <20070129111635.247181dd.akpm@osdl.org>
In-Reply-To: <20070129104943.a42f0c6c.randy.dunlap@oracle.com>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
	<20070127021834.e26e955d.akpm@osdl.org>
	<20070127181116.GA5158@Krystal>
	<20070127120512.04a98fcd.akpm@osdl.org>
	<1170095809.5833.72.camel@localhost.localdomain>
	<20070129104943.a42f0c6c.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 10:49:43 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > I could probably arrange to share an ARM toolchain if there was
> > demand...
> 
> I'd certainly like to see/use it.

http://userweb.kernel.org/~akpm/arm-cross.tar.bz2 works.  It's linked
on FC5 x86, runs OK on FC6 and FC3 or thereabouts.
