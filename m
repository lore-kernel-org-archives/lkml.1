Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYIFXIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYIFXIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYIFXGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:06:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbYIFXGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:06:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brice Goglin" <brice@myri.com>,
       "Lennert Buytenhek" <buytenh@marvell.com>,
       "Lennert Buytenhek" <buytenh@wantstofly.org>,
       "Martin Michlmayr" <tbm@cyrius.com>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.aLC.aqwwIB@albercik>
Subject: [Bug #11334] myri10ge: use ioremap_wc: compilation failure on ARM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  6 Sep 2008 23:30:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 11:25 (28 days old)
References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2
Handled-By	: Lennert Buytenhek <buytenh@wantstofly.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11334#c13


