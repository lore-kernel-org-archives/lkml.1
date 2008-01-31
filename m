Return-Path: <linux-kernel-owner+w=401wt.eu-S933881AbYAaNN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbYAaNN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765601AbYAaNNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:13:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:42113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYAaNNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:13:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=RVutjvApz0H5QRQdNutEVSgZ+cFlJM/oTkyx5JH7JQUHUsfqVxAFUfrcEej3jun0QV3zsRh3pvVbD9h0Hvs8HnzYUTzL9y93desEfLuadfo3N/APW31F/ZXGJMynTnzsfFHptP4II83S1hvIGjvnj0Knjo56ZbIgo4dwi3wZVuc=
Message-ID: <47A1C95E.2080307@gmail.com>
Date: Thu, 31 Jan 2008 14:13:02 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.77 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

Some news: the man-pages web site at http://www.kernel.org/doc/man-pages/
now includes a (Google-based) search facility for searching the pages that
are online there.

I've released man-pages-2.77.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

A full list of the changes in this release can be seen at
http://www.kernel.org/doc/man-pages/changelog.html
A summary of the changes in this release that may be of interest to readers
of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-2.77 ====================


Changes to individual pages
---------------------------

wait.2
    Phil Endecott
        Clarify description of return value for WNOHANG.

tkill.2
    mtk
        Rewrote DESCRIPTION; emphasized that tkill() is obsoleted by
        tgkill().

alloca.3
    mtk
        Various rewrites and additions (including notes on longjmp() and
        SIGSEGV).
    mtk / Vincent Lefevre
        Weaken warning against use of alloca(), and
        point out some cases where it can be useful;
        as per http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=461100.


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html

