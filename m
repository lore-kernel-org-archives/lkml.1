Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZIGTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZIGTCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZIGTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:02:24 -0400
Received: from kroah.org ([198.145.64.141]:45133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbZIGTCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:02:23 -0400
Date: Mon, 7 Sep 2009 11:55:13 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: leemgs1@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
       mathieu.desnoyers@polymtl.ca, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] debugfs - Fix mount directory of debugfs by
 default in events.txt
Message-ID: <20090907185513.GA27876@kroah.com>
References: <1252327037.2153.96.camel@centos51>
 <1252327737.7959.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252327737.7959.22.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 02:48:57PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-09-07 at 21:37 +0900, GeunSik Lim wrote:
> > 
> > >From 99e8ab48d783e619329c31e8f91e4384729a2e8b Mon Sep 17 00:00:00 2001
> > From: GeunSik,Lim <leemgs1@gmail.com>
> > Date: Mon, 7 Sep 2009 20:34:19 +0900
> > Subject: [PATCH 1/5] Fix mount directory of debugfs by default in events.txt
> > 
> > We need common default directory of denbugfs for consistency.
> > (debugfs's default directory is /sys/kernel/debug/ by debugfs.)
> 
> I'd rather we fix that brain-dead default.

Um, why is that "brain-dead"?  It was discussed many times when debugfs
first came out and this was what was decided on.

So what is the problem?

thanks,

greg k-h
