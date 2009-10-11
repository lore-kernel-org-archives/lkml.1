Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZJKXEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZJKXEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZJKXEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:04:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58079 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZJKXEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:04:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>,
       "Ricardo Jorge da Fonseca Marques Ferreira" <storm@sys49152.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.9FF.c1l0KB@chimera>
Subject: [Bug #13940] 2.6.31-rc1 - iwlagn and sky2 stopped working when ACPI enabled - Toshiba U400-17b, Acer Aspire 8935G
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
Subject		: 2.6.31-rc1 - iwlagn and sky2 stopped working when ACPI enabled - Toshiba U400-17b, Acer Aspire 8935G
Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Date		: 2009-08-07 22:33 (66 days old)
References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23280


