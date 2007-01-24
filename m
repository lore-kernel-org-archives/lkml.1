Return-Path: <linux-kernel-owner+w=401wt.eu-S1030194AbXAXEus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194AbXAXEus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 23:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030199AbXAXEur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 23:50:47 -0500
Received: from iabervon.org ([66.92.72.58]:2756 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030194AbXAXEur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 23:50:47 -0500
Date: Tue, 23 Jan 2007 23:50:45 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: 2.6.18-stable release plans?
In-Reply-To: <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701232332540.20138@iabervon.org>
References: <45B53722.9030206@redhat.com> <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Jesper Juhl wrote:

> Now that 2.6.19 is out, most likely not.  -stable releases are made
> for the latest stable 2.6.x kernel, once 2.6.x+1 is out that's the one
> -stable patches are made for (2.6.16 is an exception)..

There's generally a bit of overlap. 2.6.17.14 was about the same time as 
2.6.18.1, and 2.6.18.6 was after 2.6.19.1. But 2.6.18.x must be over now, 
because the -stable team didn't release a 2.6.18.7 to match 2.6.19.2, and 
all of 2.6.x except for 2.6.19.2 has that weird file corruption bug 
(although rarely triggered).

	-Daniel
*This .sig left intentionally blank*
