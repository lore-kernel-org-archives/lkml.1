Return-Path: <linux-kernel-owner+w=401wt.eu-S1764402AbYEXVnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764402AbYEXVnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761840AbYEXVdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:33:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761680AbYEXVdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:33:07 -0400
Cc: "Jan C. Nordholz" <jckn@gmx.net>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.g1C._dIOIB@albercik>
Subject: [Bug #10751] pciehp probing slow, duplicate kobject_add
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10751
Subject		: pciehp probing slow, duplicate kobject_add
Submitter	: Jan C. Nordholz <jckn@gmx.net>
Date		: 2008-05-19 14:26 (6 days old)


