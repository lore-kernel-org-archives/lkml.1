Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZLPSxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZLPSxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZLPSxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:53:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60672 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZLPSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:53:20 -0500
Date: Wed, 16 Dec 2009 18:53:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] VFS stuff, part 1
Message-ID: <20091216185319.GM14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216185157.GL14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 06:51:57PM +0000, Al Viro wrote:
> This ought to get rid of the bulk of namei.c patches affecting the
> areas where my and Nick's series step on the same code.  There's
> also some struct file work, plus a bunch of fixes all over the place
> (in particular, Eric's series dealing with IMA horrors, partially
> modified to merge), but most of that stuff is fighting the call
> graph in fs/namei.c and massaging things into more or less sane shape
> there.
> 
> Please, pull from
> git.kernel.org//pub/scm/linux/kernel/git/viro/vfs-2.6.git/

gyah...  

git.kernel.org//pub/scm/linux/kernel/git/viro/vfs-2.6.git/ master
