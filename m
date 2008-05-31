Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYEaTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYEaTDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYEaSv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51449 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbYEaSve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:34 -0400
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "tvrtko.ursulin" <tvrtko.ursulin@sophos.com>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.glD.ArZQIB@albercik>
Subject: [Bug #10798] kbuild variable $(src) broken in 2.6.23-rc3?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10798
Subject		: kbuild variable $(src) broken in 2.6.23-rc3?
Submitter	: tvrtko.ursulin <tvrtko.ursulin@sophos.com>
Date		: 2008-05-21 14:42 (11 days old)
References	: http://marc.info/?l=linux-kbuild&amp;m=121138246208259&amp;w=2
Handled-By	: Sam Ravnborg <sam@ravnborg.org>


