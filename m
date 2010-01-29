Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546Ab0A2Sin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0A2Sin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755Ab0A2Sim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:38:42 -0500
Received: from thunk.org ([69.25.196.29]:38564 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab0A2Sim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:38:42 -0500
Date: Fri, 29 Jan 2010 00:19:53 -0500
From: tytso@mit.edu
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
Message-ID: <20100129051953.GM28459@thunk.org>
Mail-Followup-To: tytso@mit.edu, Alexander Clouter <alex@digriz.org.uk>,
	linux-kernel@vger.kernel.org
References: <1264597747.3607.29.camel@wall-e>
 <87hbq6dy2k.fsf@basil.nowhere.org>
 <17r837-m29.ln1@chipmunk.wormnet.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17r837-m29.ln1@chipmunk.wormnet.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 04:39:29PM +0000, Alexander Clouter wrote:
> Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >> The time of 80 characters punch card and terminals are over, so i would
> >> be a good thing to set the line length limit to 120. Every display today
> >> should be able handle this. 
> >>   
> >> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > 
> > Full Ack!
> > 
> NACK Attack!
> 
> There is a reason Knuth only put so many words on a line with TeX.

Linus has already agreed that the 80 character limit is stupid.  Let's
just nuke this check from checkpatch.pl and move on.

     	       	     	  		    - Ted
