Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbXD2D3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbXD2D3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXD2D3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:29:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330AbXD2D3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:29:33 -0400
Date: Sat, 28 Apr 2007 20:28:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-Id: <20070428202849.2a506722.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704281703510.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	<20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<4630DB24.4030005@redhat.com>
	<20070426201325.8a1ebda3.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	<20070426224148.69b91b2e.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	<46339BC7.6050802@mbligh.org>
	<alpine.LFD.0.98.0704281703510.9964@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 17:07:30 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 28 Apr 2007, Martin J. Bligh wrote:
> > 
> > Go to http://bugzilla.kernel.org. Hit query. Find the box that says
> > "Bug Changes, Only bugs changed in the last __ days". Stick 7 in it.
> > 
> > 74 bugs found.
> > 
> > Not hard to do.
> 
> And what part of the "directed" did you miss?
> 
> Do you really expect me to go there every day to look at all bugs? That's 
> nbot a bug tracker. That's just a noise-maker.
> 
> It needs to be email, not some "mouse around for 30 seconds and type 
> thing", and it needs to be *directed*. Preferably with somebody who 
> actually did some manual scanning over it and spent a few minutes just 
> looking at whether it looks like a worthy bug.
> 
> In other words: we shouldn't have all developers wasting time doing this. 

yup.

> It would be much better to have _one_ person (or a group of people) doing 
> it,

I am doing that.  It's only 5-10 a day - routing them to the relevant
culprit is very little work.  It's also very little work for said culprits
to totally ignore said routing, which is a tougher problem.

