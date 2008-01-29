Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbYA2RrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbYA2RrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYA2Rqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:46:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYA2Rqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:46:48 -0500
Date: Tue, 29 Jan 2008 09:50:13 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [git pull] Fix recent Ocfs2 breakage
Message-ID: <20080129175013.GB15043@suse.de>
References: <20080129033307.GE23506@ca-server1.us.oracle.com> <20080129050804.GA2285@suse.de> <20080129055825.GG23506@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129055825.GG23506@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 09:58:25PM -0800, Mark Fasheh wrote:
> On Mon, Jan 28, 2008 at 09:08:04PM -0800, Greg KH wrote:
> > And please please please please document stuff like this, and all of the
> > different files you have in this subdirectory in Documentation/ABI/ so
> > those of us who are trying to figure out the code (and there's still
> > parts of the kobject usage I'm pretty sure is not correct) can have a
> > chance to understand exactly how this stuff is being used and expected
> > to work.
> 
> No problem. I'll get us some patches to symlink things, and add docs in
> Documentation/ABI/ explaining how Ocfs2 and userspace communicate. In the
> future, as we add ABI it'll be documented there.

Great, that would be wonderful.

thanks,

greg k-h
