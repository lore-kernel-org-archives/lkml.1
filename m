Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZFGM5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZFGM5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZFGMyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:54:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58314 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbZFGMyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:54:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alejandro Riveira" <ariveira@gmail.com>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.SVH.nZ7KKB@chimera>
Subject: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
Subject		: rt2x00: slow wifi with correct basic rate bitmap
Submitter	: Alejandro Riveira <ariveira@gmail.com>
Date		: 2009-05-22 13:32 (17 days old)


