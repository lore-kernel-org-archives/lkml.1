Return-Path: <linux-kernel-owner+w=401wt.eu-S1032223AbXHMRLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032223AbXHMRLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938075AbXHMQwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:52:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3154 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936664AbXHMQwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:52:30 -0400
Subject: Re: [PATCH] [208/2many] MAINTAINERS - GFS2 FILE SYSTEM
From: Joe Perches <joe@perches.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, akpm@linux-foundation.org
In-Reply-To: <1186995258.8765.795.camel@quoit>
References: <46bffa01.umS2rSd+AoRJwoFx%joe@perches.com>
	 <1186995258.8765.795.camel@quoit>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 09:52:07 -0700
Message-Id: <1187023927.10249.109.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 09:54 +0100, Steven Whitehouse wrote:
> This is missing:
>    F:     include/linux/lm_interface.h

Added

GFS2 FILE SYSTEM
P:	Steven Whitehouse
M:	swhiteho@redhat.com
L:	cluster-devel@redhat.com
W:	http://sources.redhat.com/cluster/
T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
S:	Supported
F:	/Documentation/filesystems/gfs2.txt
F:	fs/gfs2/
F:	include/linux/gfs2_ondisk.h
F:	include/linux/lm_interface.h


