Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYIFXTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYIFXTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbYIFXIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:08:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbYIFXIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:08:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.N4H.ZowwIB@albercik>
Subject: [Bug #11506] oops during unmount - ext3? (2.6.27-rc5)
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11506
Subject		: oops during unmount - ext3? (2.6.27-rc5)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-09-04 19:14 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122055573123449&w=4


