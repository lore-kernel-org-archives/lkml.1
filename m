Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbYF2Tf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbYF2Tf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbYF2Tb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758993AbYF2TbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:25 -0400
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.j4E.079ZIB@albercik>
Subject: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
Subject		: x86_64 boot hang when CONFIG_NUMA=n
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-06-05 21:50 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
		  http://lkml.org/lkml/2008/6/11/355
		  http://lkml.org/lkml/2008/6/15/117
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


