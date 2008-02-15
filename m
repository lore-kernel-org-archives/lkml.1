Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbYBOOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbYBOOCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYBOOCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:02:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:62795 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbYBOOCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:02:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=hgIYMSepWvi6esDulUXlTSk1SNS9ipI+dkZHeGTJd2nTFFIq02/0fgFD7Q+Q4K1FyVSC+wM/qsEIIkeCvXcSq9zZ8m9SnohYPNYDQKXLZQcm83ElKhzDbhYqJJ2HPrRpxb98ARYJqJIJ2iyvVcAczIA9EcKNy8VdaJmh9iwWlcQ=
Message-ID: <47B59B22.4010205@gmail.com>
Date: Fri, 15 Feb 2008 15:01:06 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.78 is released
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

I've released man-pages-2.78.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

A full list of the changes in this release can be seen at
http://www.kernel.org/doc/man-pages/changelog.html
A summary of the changes in this release that may be of interest to readers
of this list is provided below.

Cheers,

Michael

==================== Changes in man-pages-2.78 ====================


New pages
---------

eventfd.2
    mtk, with input and review from Davide Libenzi
        Documents the eventfd() system call, new in 2.6.22.

signalfd.2
    mtk, with input and review from Davide Libenzi
        Documents the signalfd() system call, new in 2.6.22.

Changes to individual pages
---------------------------

open.2
    Greg Banks
        Greatly expand the detail on O_DIRECT.

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html


