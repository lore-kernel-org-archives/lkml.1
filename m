Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZEXWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZEXWbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbZEXW2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:28:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759347AbZEXW23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:28:29 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Artem S. Tashkinov" <t.artem@mailcity.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
In-Reply-To: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <WCcYF-TAbJC.A.XGD.dQcGKB@chimera>
Subject: [Bug #13225] [2.6.29 regression] Software suspend no longer works
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:31:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13225
Subject		: [2.6.29 regression] Software suspend no longer works
Submitter	: Artem S. Tashkinov <t.artem@mailcity.com>
Date		: 2009-05-02 21:41 (23 days old)


