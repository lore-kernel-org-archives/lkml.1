Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbZGGANn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbZGGANn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZGGAIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:08:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58121 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbZGGAIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:08:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "=?utf-8?q?Ozan=20=C3=87a=C4=9Flayan?=" <ozan@pardus.org.tr>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.LqH.1ApUKB@chimera>
Subject: [Bug #13471] Loading parport_pc kills the keyboard if ACPI is enabled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:00:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13471
Subject		: Loading parport_pc kills the keyboard if ACPI is enabled
Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
Date		: 2009-06-04 9:12 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=124410667532558&w=4


