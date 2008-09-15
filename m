Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYIOJxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYIOJxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 05:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYIOJw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 05:52:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58479 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYIOJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 05:52:59 -0400
Date: Mon, 15 Sep 2008 11:54:27 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/27] nilfs2: add document
Message-ID: <20080915095427.GA1861@elf.ucw.cz>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +NILFS2 is a log-structured file system (LFS) supporting continuous
> +snapshotting.  In addition to versioning capability of the entire file
> +system, users can even restore files mistakenly overwritten or

Hmm, undelete done right. Just one question... how slow/fast is it
compared to conventional filesystems (ext3?)?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
