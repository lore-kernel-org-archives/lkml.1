Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbYILUxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbYILUxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbYILUpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:45:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbYILUpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:45:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dan Williams" <dcbw@redhat.com>, "Jouni Malinen" <j@w1.fi>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       "Zhu Yi" <yi.zhu@intel.com>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.fJH.jcsyIB@albercik>
Subject: [Bug #11476] failure to associate after resume from suspend to ram
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11476
Subject		: failure to associate after resume from suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-09-01 13:33 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=122028529415108&w=4
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Dan Williams <dcbw@redhat.com>
		  Jouni Malinen <j@w1.fi>


