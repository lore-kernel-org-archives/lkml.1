Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYKBSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYKBSOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYKBSDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:03:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYKBSD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:03:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Hugh Dickins" <hugh@veritas.com>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.yGE.qjeDJB@chimera>
Subject: [Bug #11940] Unable to handle kernel paging request at iov_iter_copy_from_user_atomic
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11940
Subject		: Unable to handle kernel paging request at iov_iter_copy_from_user_atomic
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2008-11-01 14:23 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=122554945922521&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>
Patch		: http://marc.info/?l=linux-kernel&m=122556602913200&w=4


