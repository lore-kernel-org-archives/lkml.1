Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZD0Osd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZD0Osd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZD0OoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:44:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797AbZD0On5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:43:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/8] Sync fixes and cleanups (version 4)
Date: Mon, 27 Apr 2009 16:43:47 +0200
Message-Id: <1240843435-1786-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  here comes the next version of sync fixes and cleanups. This version also
includes some moving of code from super.c to sync.c and quota sync cleanup and
slight speedup. If noone has any objections anymore, who's going to merge it?
Al?

								Bye
									Honza
