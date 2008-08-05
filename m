Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbYHETYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbYHETYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762615AbYHETYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:24:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:39090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762348AbYHETYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=wOjxHRKmK60KLw5cJLWMuT28cYfcwcWy+BKtA8+H+/IrqvSRhP4/14xmr08/+bcUJ9
         QuCbuUICGm+tbeE+RAqbCHSShfIQhu7hWZj/YUe9Knv6eD0C9FJ77lCQY7TKsTsw3tw6
         15T6qdgRtR+w46uu/Dir3OM2hb/SttlsSXkiY=
Message-ID: <4898A7EF.3050107@gmail.com>
Date: Tue, 05 Aug 2008 21:20:15 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.06 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.06.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2008/08/man-pages-306-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

The changes in this release consist almost entirely of a major revision
of all of the math pages to fix the discussion of return values,
errors, feature test macros, and standards conformance.  See the blog
or the online changelog for more details.

Cheers,

Michael

