Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbZGGATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbZGGATi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbZGGAKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:10:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626AbZGGAKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:10:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.BkG.-_oUKB@chimera>
Subject: [Bug #13648] nfsd: page allocation failure
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:00:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
Subject		: nfsd: page allocation failure
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2009-06-22 12:08 (15 days old)
References	: http://lkml.org/lkml/2009/6/22/309


