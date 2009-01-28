Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZA1Dif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZA1Dif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZA1Di1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:38:27 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39506 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbZA1Di0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:38:26 -0500
Date: Wed, 28 Jan 2009 14:38:24 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Greg KH <gregkh@suse.de>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128033824.GA1662@brong.net>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128003519.GA11395@suse.de>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 04:35:19PM -0800, Greg KH wrote:
> Can you resubmit all 4 patches, and cc: the epoll author, Davide?  He's
> the one that needs to accept these changes.

It's three now (two of them deserved to merged) and re-ordered so the
first two are trivial and the complex bits are easily skipped if you
don't want them.  

Just looking for Davide's email address.  Found it :)  I'll follow up
this message with the patches.  I'm not going to CC everyone else again
- but I'll CC LKML so you can follow it there if you want.

Bron.
