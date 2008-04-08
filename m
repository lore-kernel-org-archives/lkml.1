Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYDHA5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYDHA5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 20:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbYDHA50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 20:57:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:60851 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbYDHA50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 20:57:26 -0400
Subject: Re: fully bisectable real time series
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <Pine.LNX.4.58.0804072027080.7121@gandalf.stny.rr.com>
References: <1207611243.21308.167.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0804072027080.7121@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 17:57:24 -0700
Message-Id: <1207616244.21308.174.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-07 at 20:33 -0400, Steven Rostedt wrote:
> On Mon, 7 Apr 2008, Daniel Walker wrote:
> 
> >
> > I've re-worked the -rt series, and some of the core patches to make it
> > all bisectable. I've done bisect updates in the past which really only
> > scratched the surface.
> >
> 
> Daniel,
> 
> Thanks, for doing this. I'll try to look at it when I get a chance. If you
> can make a bisectable series that still gives a byte for byte identical
> kernel with a make allyesconfig, I'll incorporate it.

I haven't actually tested if it's byte for byte identical, I can or you
can review it an decide what you think of it.. The executable code parts
should be identical. I just moved patches around, patch split-ups, did
name changes, and added macros ..

Daniel

