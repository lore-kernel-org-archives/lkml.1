Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbXGKJe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbXGKJe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbXGKJek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:34:40 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36290 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758253AbXGKJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:34:39 -0400
Date: Wed, 11 Jul 2007 11:34:19 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Chris Stromsoe <cbs@cts.ucla.edu>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [git patches] net driver updates
In-Reply-To: <20070710183953.GA8898@havoc.gtf.org>
Message-ID: <Pine.LNX.4.64.0707111128330.31463@twin.jikos.cz>
References: <20070710183953.GA8898@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Jeff Garzik wrote:

> Various minor updates.  The only thing of note is sk98lin driver removal.
> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-linus

This is probably going to cause a new entry in regressions list, as at 
least Chris Stromsoe has reported bonding-related problems with skge that 
don't happen with sklin - 
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0707.1/1158.html

-- 
Jiri Kosina
