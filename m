Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbZGGAYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbZGGAYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbZGGAK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:10:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbZGGAK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:10:57 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Kaltsas" <alexkaltsas@gmail.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.L2F.0_oUKB@chimera>
Subject: [Bug #13681] A number of usb Devices causes Oops messages and kernel panics.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:01:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13681
Subject		: A number of usb Devices causes Oops messages and kernel panics.
Submitter	: Alexander Kaltsas <alexkaltsas@gmail.com>
Date		: 2009-06-30 13:06 (7 days old)


