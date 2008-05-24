Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYEXWqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYEXWqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762635AbYEXWqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:46:32 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54123 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762592AbYEXWqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:46:31 -0400
Date: Sat, 24 May 2008 18:45:54 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080524224554.GA5970@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@linux.intel.com>, Jan Kara <jack@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524153020.1df96cf2@linux.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 03:30:20PM -0700, Arjan van de Ven wrote:
> 
> Ted looked at these during the LF summit, and his conclusion was that
> they're all media errors (eg USB unplug) that ext3 then did not handle
> well at all. Maybe Ted has an update on this?
> 

Not really.  It's on my todo list but fixing a bug caused by users
doing something stupid (pulling a mounted USB stick) has been lower
than a number of other fires burning on my plate.  I'll try to get to
it but a lot of other things I need to worry about have deadlines
associated with them....

						- Ted
