Return-Path: <linux-kernel-owner+w=401wt.eu-S1762744AbZATABr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744AbZATABr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760491AbZASXxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:53:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760866AbZASXxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:53:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Adrian McMenamin" <lkmladrian@gmail.com>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.bKG.V9QdJB@chimera>
Subject: [Bug #12502] pipe_read oops on sh
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12502
Subject		: pipe_read oops on sh
Submitter	: Adrian McMenamin <lkmladrian@gmail.com>
Date		: 2009-01-15 9:48 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=123201298005600&w=4


