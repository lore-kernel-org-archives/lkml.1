Return-Path: <linux-kernel-owner+w=401wt.eu-S1763158AbYF2Tnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763158AbYF2Tnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760179AbYF2Tbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880AbYF2Tbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:34 -0400
Cc: "Alex Chiang" <achiang@hp.com>, "Robin Holt" <holt@sgi.com>,
       "Tony Luck" <tony.luck@intel.com>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.RCD.b69ZIB@albercik>
Subject: [Bug #11007] [BISECT] Boot failure on ia64.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11007
Subject		: [BISECT] Boot failure on ia64.
Submitter	: Robin Holt <holt@sgi.com>
Date		: 2008-06-24 07:30 (6 days old)
References	: http://lkml.org/lkml/2008/6/24/196
Handled-By	: Alex Chiang <achiang@hp.com>


