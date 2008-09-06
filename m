Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYIFXR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYIFXR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYIFXIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:08:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbYIFXIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:08:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "George Gibbs" <Vash63@gmail.com>, "Zhang Rui" <rui.zhang@intel.com>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.og.0owwIB@albercik>
Subject: [Bug #11471] GPE storm detected, kernel freezes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  6 Sep 2008 23:30:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11471
Subject		: GPE storm detected, kernel freezes
Submitter	: George Gibbs <Vash63@gmail.com>
Date		: 2008-08-31 22:00 (7 days old)
Handled-By	: Zhang Rui <rui.zhang@intel.com>


