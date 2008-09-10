Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYIJOmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYIJOmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYIJOl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:41:58 -0400
Received: from po-out-1718.google.com ([72.14.252.155]:52196 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYIJOl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=HHvq6twwAxfk0I4O1k0+DU7F7abHeE3PkrLgCe50SWBTN1AGuro0CsJAifS5/kFf2O
         c1ixNvwyrtPLzD69zJ4bZ6Cm4M5G4qMbkbeCHUHHtMi/R6K3/oDG99gVOPv1Ry3CH5BW
         DxRoT7kYn1r/db4RoFFWsU6GFSpO7zeCzW19I=
Message-ID: <cfd18e0f0809100741k7cd38f1se625dd8d35d5d100@mail.gmail.com>
Date: Wed, 10 Sep 2008 16:41:55 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.09 is released
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.09.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/09/man-pages-309-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael


==================== Changes in man-pages-3.09 ====================


New and rewritten pages
-----------------------

fopencookie.3
    mtk
        Document fopencookie(3), a library function that allows
        custom implementation of a stdio stream.

networks.5
    Martin (Joey) Schulze, with a few light edits by mtk
        Documents the /etc/networks file.


Changes to individual pages
---------------------------

fcntl.2
    mtk, after a note by Mike Bianchi
        More clearly and consistently describe whether
        or not the third argument to fcntl() is required,
        and what its type should be.

sched_setscheduler.2
    Carsten Emde
        Update kernel version numbers relating to real-time support.

proc.5
    Mats Wichmann / mtk
        s/\[number]/[pid]/ in file names for /proc/PID files.
        And similar changes for task/[tid] sub-directories.
    Joe Korty
        Document new fields in /proc/interrupts that were added in
        Linux 2.6.24.
