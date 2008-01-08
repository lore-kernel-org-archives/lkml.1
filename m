Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbYAHPhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbYAHPhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbYAHPhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:37:48 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:12002 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbYAHPhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:37:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=xxUumRjr1bDgdBNr8jpFOg0Uco7bkOGpQfdW7BKUzhiRN4lNJgooe6GqIpa9bOwet+LEDB26R70sTNJp6wyyOBwgmFW/SLMqessb/I0EE+OaWc9FzgloF08rf0kL9j3amBC3MpvyLiVZdjzsn9vmCKpIanz0aK59+dbXj7TJxxc=
Message-ID: <478398B1.1080903@gmail.com>
Date: Tue, 08 Jan 2008 16:37:21 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Alain PORTAL <alain.portal@univ-montp2.fr>
Subject: man-pages-2.75 and man-pages-fr-2.75.0 are released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer, Michael Kerrisk, and the maintainer of the
French translation of man-pages, Alain Portal, proudly announce the
simultaneous release (*) of man-pages-2.75 in English original and French
translation.

The English version:

    man-pages-2.75.tar.gz - man pages for Linux

is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

    The (rather long) list of changes in this release can be seen at
    http://www.kernel.org/doc/man-pages/changelog.html#release_2.75
    A short summary of the changes in this release that may be
    of interest to readers of this list is provided below.

The French translation is available for download here:

    http://manpagesfr.free.fr/download.html

The translated pages are viewable online, along with some translated man
pages from other projects, here:

    http://manpagesfr.free.fr/consulter.html

    Comments and suggestions for the French translation can be
    sent to manpagesfr@free.fr.

A huge thanks to Alain, who has over the last two and a half years made a
terrific effort to bring the French translation fully up to date with the
English original.

Cheers,

Michael

(*) See
http://linux-man-pages.blogspot.com/2007/12/man-pages-fr-2740-est-sorti.html

==================== Changes in man-pages-2.75 ====================

Changes to individual pages
---------------------------

arch_prctl.2
    mtk, Acked by Andi Kleen
        Clarify interpretation of 'addr'; plus a few other minor edits
        and updates.

close.2
    mtk
        Clarify relationship between file descriptor and open file
        description.

connect.2
    mtk, Acked by Andi Kleen
        Since kernel 2.2, AF_UNSPEC for unconnecting a connected
        socket *is* supported.

listen.2
    mtk
        Rewrote various parts.

open.2
    mtk
        Clarify initial description of O_EXCL.
        Clarify description of behaviors of O_CREAT | O_EXCL
        for symbolic links.
        Clarify text describing use of lockfiles without O_EXCL.
    mtk, with input from Timo Sirainen and Trond Myklebust
        O_EXCL is supported on NFSv3 and later, with Linux 2.6 and later.

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html





