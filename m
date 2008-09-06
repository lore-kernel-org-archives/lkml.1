Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYIFXUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYIFXUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYIFXIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:08:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbYIFXIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:08:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Masoud Sharbiani" <masouds@google.com>,
       "Masoud Sharbiani" <masouds@masoud.ir>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.ovH.UowwIB@albercik>
Subject: [Bug #11511] HPT374 detection crash with 74811f355f4f69a187fa74892dcf2a684b84ce99
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  6 Sep 2008 23:30:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11511
Subject		: HPT374 detection crash with 74811f355f4f69a187fa74892dcf2a684b84ce99
Submitter	: Masoud Sharbiani <masouds@masoud.ir>
Date		: 2008-09-04 23:11 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122056994113818&w=4
Handled-By	: Masoud Sharbiani <masouds@google.com>
Patch		: http://marc.info/?l=linux-kernel&m=122072163527041&w=4


