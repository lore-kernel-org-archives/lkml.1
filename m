Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYEEKJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYEEKJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYEEKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:09:26 -0400
Received: from styx.suse.cz ([82.119.242.94]:43857 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752437AbYEEKJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:09:26 -0400
Date: Mon, 5 May 2008 12:09:25 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled
	-> journaled)
Message-ID: <20080505100924.GB25722@duck.suse.cz>
References: <12095679813226-git-send-email-jack@suse.cz> <12095679812375-git-send-email-jack@suse.cz> <12095679812452-git-send-email-jack@suse.cz> <1209567981639-git-send-email-jack@suse.cz> <20080430104330.66c44d4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430104330.66c44d4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-08 10:43:30, Andrew Morton wrote:
> On Wed, 30 Apr 2008 17:06:15 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > -					"EXT3-fs: Cannot change journalled "
> > +					"EXT3-fs: Cannot change journaled "
> 
> hrm, who said?
> 
> Dictionary.com recognises neither.
> 
> google(journalled) = 520,000
> google(journaled) = 652,000
  google.cz gives like 250k vs 519k, interesting. Anyway, I'm happy to
leave the decision on the proper spelling of the verb to people with better
English skills ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
