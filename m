Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbYEXVeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbYEXVeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762462AbYEXVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:32:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40126 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762413AbYEXVcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:32:46 -0400
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Miles Lane" <miles.lane@gmail.com>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.ghF.ZgIOIB@albercik>
Subject: [Bug #10628] 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10628
Subject		: 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2008-05-04 21:12 (21 days old)
References	: http://lkml.org/lkml/2008/5/4/309
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


