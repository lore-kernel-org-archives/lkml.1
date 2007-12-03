Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXLCRhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXLCRhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXLCRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:37:28 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:7518 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXLCRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:37:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=ia7OlnezAOq2tw8qhabSf/BMFMwvo45rt7n5QDDADxYgBNYBQeQG4/4GpqglKMrZGe7unUiOGZwaQeBy3nHMyJoWEtOGis4FO093vEOpcV2trit+WHiksVGeq3HrtJc8InLqvBIRSBWgumyNx96MXfsZL3pttowSUhvzrhzm/tM=
Message-ID: <47543F81.4030805@gmail.com>
Date: Mon, 03 Dec 2007 18:40:17 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.69 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

Some news:

* man-pages now has a website:

      http://www.kernel.org/doc/man-pages

  The site includes HTML versions of the current set of man-pages.

* Starting with man-pages-2.69, each man page now includes a COLOPHON
  section at the end of the page which indicates the version of
  man-pages in which this page is released, and also contains a
  pointer to the man-pages web site.

Repeating some old news:

* As from now, my address as man-pages maintainer has changed
  to mtk.manpages@gmail.com.  (Mail to the old address will
  continue to work for a while, but eventually I will close
  that account.)

* The list linux-man@vger.kernel.org has been created for
  the purpose of discussing Linux man page bugs, patches,
  and maintenance.  To subscribe, send a message to
  majordomo@vger.kernel.org, with the body:

       subscribe linux-man

Back to the news as usual...

I recently released man-pages-2.69.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

    (Note the s/manpages/man-pages/ in these paths;
    a symlink with the old path will exist for
    a limited time.)

Changes in the release that may be of interest to readers of this list are
summarized below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)


==================== Changes in man-pages-2.69 ====================

Removed pages
-------------

HOWTOHELP
MAINTAINING
    mtk
        The content of these files is now available in HTML format.


Changes to individual pages
---------------------------

fcntl.2
    J. Bruce Fields
        Add warning that mandatory locking is unreliable.
    J. Bruce Fields
        Clarify details in description of file leases.

sched_setscheduler.2
    Mats Wichmann
        Add BUGS text noting that the return value from Linux
        sched_setschuler() does not conform to POSIX.

spu_create.2
    Jeremy Kerr
        Various updates and improvements.

spu_run.2
    Jeremy Kerr
        Various updates and improvements.

spufs.7
    Jeremy Kerr
        Various updates and improvements.

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
(Sections 2, 3, 4, 5, and 7 of the Linux man pages)
http://www.kernel.org/doc/man-pages/





