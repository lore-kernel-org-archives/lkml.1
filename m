Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYFQLhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYFQLhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 07:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYFQLgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 07:36:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:21338 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbYFQLgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 07:36:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=Y62Q3uWTWYOfaI8+Q3ZUymgqU9lyPDazb12/TpNLIN4+3PrV4kgQi9RtFTCxWKn0wc
         VHRHHcb76n7wGZqLhnOkxBjmcJjLbVkcKqUzec4FCIybxW7GoezwjSoCG/kOjqZoAUYk
         N05OIRdkTXew2XFkQ6v7DJkbvj7pdSc/Fwi4Y=
Message-ID: <4857A1A4.7000803@gmail.com>
Date: Tue, 17 Jun 2008 13:36:04 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Jim Zemlin <jzemlin@linux-foundation.org>
Subject: man-pages-3.00 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.00.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The change of version number reflects a number of current and planned changes
in man-pages.  The most notable recent change is that my work on man-pages is
now supported by a fellowship from the Linux Foundation
(http://linux-man-pages.blogspot.com/2008/06/man-page-is-now-supported.html ).

A full list of the changes in this release can be seen at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/06/man-pages-300-is-released.html )

The most significant change in this release is that the POSIX man-pages
(Sections 0p, 1p, 3p) are now split out into a separate package, which can be
downloaded here:

http://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/

The split made sense because the POSIX pages are logically separate from the
Linux man pages.  (The POSIX pages are simply copies of text from the
POSIX.1-2003 specification, which we have been granted permission to publish
for Linux.  The only kinds of updates these pages see are occasional
formatting fixes, and of course updates when new revisions of the standard
appear, such as the next revision due to appear later this year.)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages onlne: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

