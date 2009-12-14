Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZLNOaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZLNOaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbZLNOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:30:22 -0500
Received: from thunk.org ([69.25.196.29]:38181 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440AbZLNOaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:30:20 -0500
Date: Mon, 14 Dec 2009 09:30:00 -0500
From: tytso@mit.edu
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ext4: Don't ask about supporting ext2/3 in ext4 if
 ext4 is not configured
Message-ID: <20091214143000.GA4867@thunk.org>
Mail-Followup-To: tytso@mit.edu, David Howells <dhowells@redhat.com>,
	torvalds@osdl.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 01:55:46PM +0000, David Howells wrote:
> Don't offer to build ext2/3 support into ext4 if ext4 itself is not configured
> on.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Whoops, nice catch.  Added to the ext4 patch queue, I'll make sure
this gets pushed to Linus during the merge window.

     	  	    	  	     - Ted
