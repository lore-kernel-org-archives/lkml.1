Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbYILVAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbYILVAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbYILUqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:46:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42931 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758706AbYILUqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:46:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.UXF.gbsyIB@albercik>
Subject: [Bug #11559] 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11559
Subject		: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-09-12 8:31 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122121384705262&w=4


