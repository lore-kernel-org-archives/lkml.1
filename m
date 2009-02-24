Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbZBXOQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbZBXOQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZBXOP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:15:58 -0500
Received: from thunk.org ([69.25.196.29]:39595 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZBXOP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:15:57 -0500
Date: Tue, 24 Feb 2009 09:15:48 -0500
From: Theodore Tso <tytso@mit.edu>
To: Tomas M <tomas@slax.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New filesystem for Linux kernel
Message-ID: <20090224141548.GB5482@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Tomas M <tomas@slax.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3AC14.2050107@slax.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 09:13:08AM +0100, Tomas M wrote:
> An overview of aufs2 has been submitted to this list.
> I noticed zero response at all. Nobody cares?
> 
> I suggest to remove unionfs from Andrew's -mm tree and replace it by aufs2!
> Tell me why this should not happen...

Um, you need to tell us why aufs2 is better than Unionfs.  The burden
of proof rests on your shoulders.  The code which is displacing
existing code needs to give a justification about why it is better
than the code which is displacing, not the other way around.

> I write this in the hope that a debate will start...

As a debate judge might say, you haven't even made your prima facie
case yet.

						- Ted
