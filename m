Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbZATAC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbZATAC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbZASXxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:53:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40385 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761019AbZASXxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:53:43 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin Madru" <jdm64@gawab.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.C4F.Q9QdJB@chimera>
Subject: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12505
Subject		: 2.6.29-rc1 Firefox crashing on page load
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2009-01-16 20:56 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=123213941914274&w=4
Handled-By	: Justin P. Mattock <justinmattock@gmail.com>


