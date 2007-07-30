Return-Path: <linux-kernel-owner+w=401wt.eu-S968539AbXG3UDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968539AbXG3UDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968404AbXG3UDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:03:24 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44049 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968396AbXG3UDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:03:20 -0400
Date: Mon, 30 Jul 2007 23:03:18 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Ismail =?iso-8859-2?q?D=F6nmez?= <ismail@pardus.org.tr>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [2/3] 2.6.23-rc1: known regressions v3
In-Reply-To: <200707302208.20891.ismail@pardus.org.tr>
Message-ID: <Pine.SOC.4.64.0707302301290.14147@math.ut.ee>
References: <46AE0F5D.3000500@googlemail.com> <46AE12F5.4030706@googlemail.com>
 <200707302208.20891.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-851401618-1185825798=:14147"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-851401618-1185825798=:14147
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

> > Subject         : New ACPI error/warning with Linus' latest GIT
> > References      : http://lkml.org/lkml/2007/7/26/395
> > Last known good : ?
> > Submitter       : Ismail Dönmez <ismail@pardus.org.tr>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : unknown
> 
> This started to happen after the second ACPI merge which was for 2.6.23-rc2.

It appeared after new Embedded Controller code was merged into ACPI. It 
might as well be just a debug message or a remainder to add support for 
new queries (whatever these are), but I do not know. The message itself 
seems harmless.

-- 
Meelis Roos (mroos@linux.ee)
---559023410-851401618-1185825798=:14147--
