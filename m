Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZDFV4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZDFV4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbZDFVvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:51:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759901AbZDFVvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:51:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, "Lin Ming" <ming.m.lin@intel.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.l9H.UGn2JB@chimera>
Subject: [Bug #12908] acpi_ex_extract_from_field -- div by zero
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12908
Subject		: acpi_ex_extract_from_field -- div by zero
Submitter	: Jiri Slaby <jirislaby@gmail.com>
Date		: 2009-03-15 10:47 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=123711408225013&w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>


