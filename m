Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZBYCTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZBYCTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZBYCTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:19:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:54845 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZBYCTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:19:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Dru6cjK/LNkrR9c0432eo0kxN0hrz84XiJ5ZCLmfJixRSF28bEm1/rfQnSB0JQDd02
         3pdD3gnRprDIK+mBnmlSTsnNHPbZccN4Ps9Q7lGPcj7qLghkqdn4Dazd9bqea0Okyks4
         Zr4Qf6chsIAEOzhEiOhF6QsZayLDrZculQB5g=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
Date: Wed, 25 Feb 2009 15:19:36 +1300
Message-ID: <cfd18e0f0902241819m15e737ebjd6ad40be1c08818e@mail.gmail.com>
Subject: man-pages-3.19 is released
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.19.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/02/man-pages-319-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael

=================== Changes in man-pages-3.19 ===================

Released: 2009-02-20, Putaruru


Contributors
------------

The following people contributed notes, ideas, or patches that have
been incorporated in changes in this release:

Christian Siebert <christian.siebert@gmail.com>
Jan Engelhardt <jengelh@medozas.de>
Jens Thoms Toerring <jt@toerring.de>
Kir Kolyshkin <kir@openvz.org>
Mark Hills <mark@pogo.org.uk>
Michael Kerrisk <mtk.manpages@gmail.com>
Parag Warudkar <parag.lkml@gmail.com>
Peter Zijlstra <a.p.zijlstra@chello.nl>
Sami Liedes <sliedes@cc.hut.fi>

Apologies if I missed anyone!


New and rewritten pages
-----------------------

timer_create.2
    Michael Kerrisk
        New page documenting timer_create(2)

timer_delete.2
    Michael Kerrisk
        New page documenting timer_delete(2)

timer_getoverrun.2
    Michael Kerrisk
        New page documenting timer_getoverrun(2)

timer_settime.2
    Michael Kerrisk
        New page documenting timer_settime(2) and timer_gettime(2)


Changes to individual pages
---------------------------

proc.5
    Michael Kerrisk
        Add description of /proc/sys/kernel/sysrq
            Reported by: Goerghe Cosorea <gheorghe.coserea@gmail.com>
