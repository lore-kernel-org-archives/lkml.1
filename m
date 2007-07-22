Return-Path: <linux-kernel-owner+w=401wt.eu-S1764187AbXGVUKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764187AbXGVUKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762070AbXGVUK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:10:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1603 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759016AbXGVUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:10:28 -0400
Date: Sun, 22 Jul 2007 16:09:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: nigel@suspend2.net, <jbms@cmu.edu>, <rjw@sisk.pl>, <miltonm@bga.com>,
       <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>, <david@lang.hm>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <E1ICeHX-00025u-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0707221608140.16031-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Miklos Szeredi wrote:

> > The only thing to do is what Rafael has been working on: unfreeze
> > things, hope the tasks sort themselves out, and try again.
> 
> Have we some proof, that this will untangle the freezing tasks in a
> limited time?  Or will it just make the problem harder to trigger?

Of course there's no proof.  Just the opposite -- if things get hung up
the first time, they might get hung up the second time.  And the
third...

But it ought to make the problem harder to trigger.  For the present 
that's a worthwhile improvement.

Alan Stern

