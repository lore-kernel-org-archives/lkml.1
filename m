Return-Path: <linux-kernel-owner+w=401wt.eu-S1763000AbZATADs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000AbZATADs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761080AbZASXxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:53:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40392 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761024AbZASXxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:53:44 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.2sF.M9QdJB@chimera>
Subject: [Bug #12507] e100: netconsole not functional because of missing firmware
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12507
Subject		: e100: netconsole not functional because of missing firmware
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2009-01-17 16:08 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=123220854426857&w=4


