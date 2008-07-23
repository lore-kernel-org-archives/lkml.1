Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYGWTma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYGWTma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYGWTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:42:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:56327 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYGWTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=XrB2dwPUbeGcBBX7MPp6ojsWquzh+L/nvwU/R6jLRLjILUdPCSuL68L1WgkWgty4ML
         nmQSt3oCNwqpBcsG26tDBm4PPYYzzjgJsQyXbS6cU0S12NEuCphUuANbDkZhKtQu0VU6
         /nc7e2++6+/jI4yy4gh+WrfXLxivTFG1zxH2g=
Message-ID: <488788B3.6060407@gmail.com>
Date: Wed, 23 Jul 2008 21:38:27 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.05 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.05.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/07/man-pages-305-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael
==================== Changes in man-pages-3.05 ====================

Released: 2008-07-23, Konolfingen


New and rewritten pages
-----------------------

matherr.3
     mtk, with review by Andries Brouwer
         A description of the SVID-specified mechanism for reporting
         math exceptions.
         See http://thread.gmane.org/gmane.linux.man/266.

math_error.7
     mtk, with review and suggested input from Andries Brouwer
         A description of how math functions report errors.
         See http://thread.gmane.org/gmane.linux.man/249.


Changes to individual pages
---------------------------

ipv6
     mtk, after a report from Uli Schlacter
         Document the IPV6_V6ONLY flag.



