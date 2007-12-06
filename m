Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbXLFJSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbXLFJSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXLFJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:18:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:37810 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbXLFJSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:18:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=PzLkzzVXnmk3+5l537hjOz37m5YI8r6KjWI89EqfRYdZ92V2XPitl5QeD3QYysPdxwVx8TZpMrU5wdJh/CExA/UqF3tA7hF0M8rJS4FfJBqQGz4BLmYvR7VUyWupE76SPBghS2NVrTa3sN5KGG+1BK6EGNOTUKphTc4UhNdUtMI=
Message-ID: <4757BEF0.7070909@gmail.com>
Date: Thu, 06 Dec 2007 10:20:48 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.70 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

Some news:

* man-pages now has an (irregularly updated) blog:

      http://linux-man-pages.blogspot.com/

* Since man-pages-2.69, each man page now includes a COLOPHON
  section at the end of the page which indicates the version of
  man-pages in which this page is released, and also contains a
  pointer to the man-pages web site.

Repeating some old news:

* man-pages now has a website:

      http://www.kernel.org/doc/man-pages

  The site includes HTML versions of the current set of man-pages.

* The list linux-man@vger.kernel.org has been created for
  the purpose of discussing Linux man page bugs, patches,
  and maintenance.  To subscribe, send a message to
  majordomo@vger.kernel.org, with the body:

        subscribe linux-man

Back to the news as usual...

I recently released man-pages-2.70.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

    (Note the s/manpages/man-pages/ in these paths;
    a symlink with the old path will exist for
    a limited time.)

Changes in this release consist primarily of formatting and consistency fixes.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/

