Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbZC3V6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbZC3V6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbZC3V6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:58:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:11583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbZC3V6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=aqZqZn1JbcnkdfuNrE/akeGawrBrwMKGL5HwLyEMfJWZTla74olm5fu23/g2LQFh3R
         1fnZeW9Th379jFK3ksY9IsFLq6wQEjBL7oxGf5r3xDsabXSRX1V56zhUfcrjZxz8RCEp
         qUieu9Z7gkLf6/swTT/SCB/0Jrs/xgoPspwY0=
Message-ID: <49D14005.4060703@gmail.com>
Date: Tue, 31 Mar 2009 10:56:21 +1300
From: Michael Kerrisk <mtk.manpages@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.20 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.20.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/03/man-pages-320-is-released.html )
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael

==================== Changes in man-pages-3.20 ====================

Released: 2009-03-31, Christchurch


New and rewritten pages
-----------------------

cpuid.4
    Andi Kleen
        New page for cpuid access device

msr.4
    Andi Kleen
        New page documenting x86 CPU MSR access device


Newly documented interfaces in existing pages
---------------------------------------------

proc.5
    Américo Wang
        Document /proc/sys/vm/swappiness
    Michael Kerrisk
        Document /proc/sysrq-trigger
