Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYILU4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYILU4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbYILUqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:46:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758192AbYILUp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:45:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jason Vas Dias" <jason.vas.dias@gmail.com>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.yYG.BcsyIB@albercik>
Subject: [Bug #11516] severe performance degradation on x86_64 going from 2.6.26-rc9 -&gt; 2.6.27-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11516
Subject		: severe performance degradation on x86_64 going from 2.6.26-rc9 -&gt; 2.6.27-rc5
Submitter	: Jason Vas Dias <jason.vas.dias@gmail.com>
Date		: 2008-09-07 13:59 (6 days old)


