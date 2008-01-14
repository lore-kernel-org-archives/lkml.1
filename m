Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYANLHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYANLHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYANLHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:07:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:11372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYANLHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=dZbr1ccU5O2Eh5dJxRb8Y5AyxVEGTAszibTmJGN5Dmlc+3cLhzW4L5GqzeBPelri4TnWC6TSOpTIp2b1Is6bOiHZvHZ1yhRgw0faw6NXiKaiMy7IXpj3plP3BNSvuJodoBYaCICwfFW/GfJMVFQ7eysX9GTFkt25b/vUUquGPL0=
Message-ID: <478B4258.3090004@gmail.com>
Date: Mon, 14 Jan 2008 12:07:04 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.76 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-2.76.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

Changes in this release can be seen at
http://www.kernel.org/doc/man-pages/changelog.html#release_2.76
A summary of the changes in this release that may be of interest to readers
of this list is provided below.

Cheers,

Michael


==================== Changes in man-pages-2.76 ====================

Changes to individual pages
---------------------------

dup.2
    mtk
        Reordered text in DESCRIPTION and added some details for dup2().

gettid.2
    mtk
        Rewrote DESCRIPTION; noted that thread ID is not the same
        thing as a POSIX thread ID.

pipe.2
    mtk
        Rewrote DESCRIPTION; minor additions to EXAMPLE text.

umask.2
    mtk
        A few rewrites and additions.

random.4
    mtk, after a report by Daniel Kahn Gilmor
        Add 2.6 details for /proc/sys/kernel/random/poolsize.
        as per http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=459232.

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html

