Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbXFYJid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbXFYJid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXFYJi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:38:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:52454 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751350AbXFYJiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:38:25 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18cFzoeeuccix/nV9d+3zbQPCj8zUhsNTvppHufbb
	NyqoWt1r4Oj7CK
Message-ID: <467F8D1C.8030706@gmx.net>
Date: Mon, 25 Jun 2007 11:38:36 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.58 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I just released man-pages-2.58.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

Some changes in this release that may be of interest to readers of this
list are noted below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

==================== Changes in man-pages-2.58 ====================

Global changes
--------------

Various pages, as detailed below
    mtk
        Added or updated VERSIONS sections.

New pages
---------

credentials.7
    mtk
        An overview of Linux process identifiers (PIDs, PPIDs,
        PGIDS, SIDs, UIDs, GIDs).


Changes to individual pages
---------------------------

listen.2
    mtk
        Updated discussion of somaxconn limit.

strcat.3
    Marc Boyer
        Improve the discussion of strncat().

strcpy.3
    Marc Boyer
        Improve the discussion of strncpy().

proc.5
    mtk
        Added discussion of /proc/sys/net/core/somaxconn.


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
