Return-Path: <linux-kernel-owner+w=401wt.eu-S1030624AbXD1BFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624AbXD1BFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030727AbXD1BFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:05:47 -0400
Received: from gw.goop.org ([64.81.55.164]:37674 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030624AbXD1BFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:05:39 -0400
Message-ID: <46329DE3.6020307@goop.org>
Date: Fri, 27 Apr 2007 18:05:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <463292C8.9000307@goop.org> <20070428010043.GA21136@srcf.ucam.org>
In-Reply-To: <20070428010043.GA21136@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> While that would certainly be nifty, I think we're arguably starting 
> from the wrong point here. Why are we booting a kernel, trying to poke 
> the hardware back into some sort of mock-quiescent state, freeing memory 
> and then (finally) overwriting the entire contents of RAM rather than 
> just doing all of this from the bootloader?

Sure, you could make suspend generate a complete bootable kernel image
containing all RAM.  Doesn't sound too hard to me.  You know, from over
here on the sidelines.

    J
