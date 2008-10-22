Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbYJVVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbYJVVxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbYJVVxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:53:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34272 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966AbYJVVw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:52:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Tracking of regressions from 2.6.27
Date: Wed, 22 Oct 2008 23:57:25 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810222357.26233.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

Since the merge window is about to close, I'm startig to collect bug reports
for the first bunch of regressions from 2.6.27.

There already is http://bugzilla.kernel.org/show_bug.cgi?id=11808 that will be
used for the tracking, so if you report a regression from 2.6.27 with the
Bugzilla, please make sure that your bug entry depends on bug #11808.

Thanks,
Rafael
