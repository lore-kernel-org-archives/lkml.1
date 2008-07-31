Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYGaSmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYGaSmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYGaSmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:42:24 -0400
Received: from sous-sol.org ([216.99.217.87]:54149 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752308AbYGaSmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:42:23 -0400
X-Greylist: delayed 3580 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 14:42:22 EDT
Date: Thu, 31 Jul 2008 09:53:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org, greg@kroah.com,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH stable] ftrace document crucial update
Message-ID: <20080731165335.GA14310@sequoia.sous-sol.org>
References: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> It has come to my attention that ftrace.txt was pulled into 2.6.26 
> prematurely. That is Linus pulled it in before it was well tested. A 
> series of updates were made to it shortly afterward, but by then it was 
> too late. The release was out, and ftrace.txt was greatly inadequate.
> 
> This patch is a sum of all the critical updates to keep ftrace.txt in a 
> stable state. I strongly urge the stable team to get this into 2.6.26.1.
> Otherwise people may be greatly disappointed while reading ftrace.txt just 
> to realize that it is horribly out of date.
> 
> Never mind that ftrace itself doesn't exist is 2.6.26.

.txt only patch is quite low-risk, but given the above, is it really that
critical?

thanks,
-chris
