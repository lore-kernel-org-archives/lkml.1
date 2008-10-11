Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbYJKEZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbYJKEZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 00:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYJKEZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 00:25:24 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52742 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750829AbYJKEZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 00:25:23 -0400
Date: Sat, 11 Oct 2008 00:25:19 -0400
From: Theodore Tso <tytso@mit.edu>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: adilger@sun.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 0/4] ext4/jbd2: possible filesystem corruption fixes
Message-ID: <20081011042519.GB8145@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, jack@suse.cz
References: <48EF168A.4000705@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EF168A.4000705@hitachi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 05:47:06PM +0900, Hidehiro Kawai wrote:
> Hi,
> 
> This patch set fixes ext4 fs corruption problems caused by
> transient I/O error.  The ext3/jbd version is already in the
> current -mm.

Hidehiro-san,

Thanks for the patches.  I've added them to the ext4 patch queue.
They weren't pushed to Linus in the first set of patches, because I
haven't yet had time to examine them closely, but I am in the process
of testing them.

Regards,

						- Ted
