Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYEKVIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYEKVIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759197AbYEKVBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34102 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084AbYEKVB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:27 -0400
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>, "Jan Kara" <jack@suse.cz>,
       "Theodore Tso" <tytso@mit.edu>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.40H.Sw1JIB@chimera>
Subject: [Bug #10633] Problem mounting ext2 using ext3 (or any failure to mount a partition) leads to an oops.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10633
Subject		: Problem mounting ext2 using ext3 (or any failure to mount a partition) leads to an oops.
Submitter	: Geert Uytterhoeven <geert@linux-m68k.org>
Date		: 2008-05-05 17:12 (7 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2281.html
Handled-By	: Theodore Tso <tytso@mit.edu>
		  Jan Kara <jack@suse.cz>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121006820018050&amp;w=2


