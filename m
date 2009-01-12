Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZALWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZALWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbZALWWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:22:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:57738 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbZALWWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=wGhMZReEl6sx0MacVnLNXzUKOEQg3tUS2/acD3rYsKP4wrv9I2csMTyhXxDwVZ5kMs
         GqKS+jL1kZUcKOhRcnnYdFLEY+bxlBA+v8olUZHs7kCx2M3ss1JFGdGW62PW8eruvX5+
         NR1a7eqJngUMzd5T2RKPAfYBQSzwMv2sUSKGE=
Message-ID: <496BC273.9040005@gmail.com>
Date: Tue, 13 Jan 2009 11:21:39 +1300
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.16 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.16.tar.gz - man pages for Linux

This release is now available for download at:

  http://www.kernel.org/pub/linux/docs/man-pages
  or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

  git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/01/man-pages-316-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael



==================== Changes in man-pages-3.16 ====================


New and rewritten pages
-----------------------

pthread_getcpuclockid.3
    Michael Kerrisk
        New page documenting pthread_getcpuclockid(3)

libc.7
    Michael Kerrisk
        New page giving brief overview of C libraries on Linux

rtld-audit.7
    Michael Kerrisk
        New page documenting dynamic linker audting API


Newly documented interfaces in existing pages
---------------------------------------------

ld.so.8
    Petr Baudis
        Document LD_AUDIT
    Petr Baudis
        Document LD_POINTER_GUARD
