Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZCFPzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZCFPzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZCFPz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:55:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58138 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754581AbZCFPzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:55:25 -0500
Date: Fri, 6 Mar 2009 10:55:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Walker <dwalker@fifo99.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Yinghai Lu <yinghai@kernel.org>,
       <mingo@redhat.com>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <ebiederm@xmission.com>, <akpm@linux-foundation.org>, <gregkh@suse.de>,
       <tglx@linutronix.de>, <sarah.a.sharp@intel.com>, <mingo@elte.hu>,
       <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
In-Reply-To: <1236351828.5937.130.camel@desktop>
Message-ID: <Pine.LNX.4.44L0.0903061052510.3461-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009, Daniel Walker wrote:

> On Fri, 2009-03-06 at 09:57 -0500, Alan Stern wrote:
> 
> > It is _not_ diehard, at least not according to Linus.  He has posted a 
> > couple of messages expressing his opinion that overall readability is 
> > more important than sticking rigidly to 80 columns.
> 
> My experience has been that anyone sending over 80 columns is sure to
> get slammed, just like with this document patch. So when I say it's die
> hard that's what I mean. Plus we have the checkpatch clean phenomenon.
> So Linus may not care but everyone else on this list does seem to care..

Well, I wouldn't have said anything if you ran over by only a few 
characters.  But your line was 97 characters long!

Alan Stern


