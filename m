Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYJ2VjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYJ2VjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYJ2VjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:39:08 -0400
Received: from mx1.suse.de ([195.135.220.2]:45054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYJ2VjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:39:04 -0400
Date: Wed, 29 Oct 2008 14:39:02 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-wireless@vger.kernel.org, Joel Becker <Joel.Becker@oracle.com>
Subject: Re: linux-next: Tree for October 28
Message-ID: <20081029213902.GF15154@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <20081028183055.fbcf5420.sfr@canb.auug.org.au> <20081028220741.f5d331ba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028220741.f5d331ba.akpm@linux-foundation.org>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:07:41PM -0700, Andrew Morton wrote:
> plus of course enough compile warnings to start a small war.   ocfs2 is
> prominent.
> 
> fs/ocfs2/xattr.c: In function `ocfs2_xattr_index_block_find':
> fs/ocfs2/xattr.c:2338: warning: long long unsigned int format, u64 arg (arg 7)
> fs/ocfs2/xattr.c:2338: warning: long long unsigned int format, u64 arg (arg 7)
> fs/ocfs2/xattr.c:2338: warning: long long unsigned int format, u64 arg (arg 7)

Thanks for pointing these out Andrew. They slipped by me. I'll get them
fixed up before the conflict escalates  ;)
	--Mark

--
Mark Fasheh
