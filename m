Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYGaULA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYGaULA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYGaUKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:10:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYGaUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:10:51 -0400
Date: Thu, 31 Jul 2008 16:10:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Greg KH <greg@kroah.com>
cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH stable] ftrace document crucial update
In-Reply-To: <20080731164850.GA10422@kroah.com>
Message-ID: <alpine.DEB.1.10.0807311610021.5784@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com> <20080731164850.GA10422@kroah.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 31 Jul 2008, Greg KH wrote:

> On Wed, Jul 30, 2008 at 11:05:02PM -0400, Steven Rostedt wrote:
> > 
> > It has come to my attention that ftrace.txt was pulled into 2.6.26 
> > prematurely. That is Linus pulled it in before it was well tested. A 
> > series of updates were made to it shortly afterward, but by then it was 
> > too late. The release was out, and ftrace.txt was greatly inadequate.
> > 
> > This patch is a sum of all the critical updates to keep ftrace.txt in a 
> > stable state. I strongly urge the stable team to get this into 2.6.26.1.
> > Otherwise people may be greatly disappointed while reading ftrace.txt just 
> > to realize that it is horribly out of date.
> > 
> > Never mind that ftrace itself doesn't exist is 2.6.26.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> Then why don't I just delete the file from the 2.6.26 tree entirely?
> That would make more sense, right?

Nope! I'm leading by example here. We should have good documentation 
before the code! ;-)

-- Steve

