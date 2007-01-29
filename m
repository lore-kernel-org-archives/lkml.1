Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbXA2WhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbXA2WhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXA2WhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:37:15 -0500
Received: from paragon.brong.net ([66.232.154.163]:53338 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbXA2WhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:37:13 -0500
X-Greylist: delayed 1441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 17:37:13 EST
Date: Tue, 30 Jan 2007 09:13:00 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Mike Houston <mikeserv@bmts.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: How many people are using 2.6.16?
Message-ID: <20070129221300.GC19422@brong.net>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129160448.65fc63f3.mikeserv@bmts.com>
Organization: brong.net
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 04:04:48PM -0500, Mike Houston wrote:
> On Mon, 29 Jan 2007 15:30:00 -0500
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > Is there any way to estimate the size of the user base for 2.6.16?
> > 
> > e.g. how many downloads does it get?
> 
> I've often wondered that myself, as I'm concerned for it to continue
> to be maintained. I'm very appreciative of what Adrian is doing with
> it. (Thanks!)

We're still running 2.6.16 kernels on a bunch of machines, though 2.6.19
has been looking pretty nice on the couple of machines that are testing
it.  2.6.17 and 2.6.18 felt less stable.

We do a lot of Cyrus which does a lot of MMAP - and we also use the 
Areca driver - which are both strong reasons to move to 2.6.19.2, but
if the MMAP fix was ported back to 2.6.16 we might consider staying
there instead.

Bron.
