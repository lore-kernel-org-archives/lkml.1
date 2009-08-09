Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZHJADx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZHJADx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZHJADw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:03:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44010 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZHJADv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:03:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Hill" <hilld@binarystorm.net>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
In-Reply-To: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRuaDVjxFBG.A.OzG._G2fKB@chimera>
Subject: [Bug #13219] Intel 440GX: Since kernel 2.6.30-rc1, computers hangs randomly but not with kernel <= 2.6.29.6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 23:10:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13219
Subject		: Intel 440GX: Since kernel 2.6.30-rc1, computers hangs randomly but not with kernel <= 2.6.29.6
Submitter	: David Hill <hilld@binarystorm.net>
Date		: 2009-05-01 16:57 (101 days old)


