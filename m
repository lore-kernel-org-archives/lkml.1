Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZBOJ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZBOJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 04:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZBOJ0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 04:26:00 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43790 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZBOJZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 04:25:59 -0500
Date: Sun, 15 Feb 2009 10:27:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kbuild: add sys_* entries for syscalls in tags
Message-ID: <20090215092750.GC29094@uranus.ravnborg.org>
References: <20090125100553.GA18239@debian> <20090125111856.GA3268@x200.localdomain> <20090125130912.GA21034@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125130912.GA21034@debian>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 06:39:12PM +0530, Rabin Vincent wrote:
> Currently, it is no longer possible to use the tags file to jump to
> system call function definitions with sys_foo, because the definitions
> are obscured by use of the SYSCALL_DEFINE* macros.
> 
> This patch adds the appropriate option to ctags to make it see through
> the macro.  Also, it adds the ENTRY() work already done for Exuberant
> to Emacs too.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Applied to kbuild-fixes.git.

	Sam
