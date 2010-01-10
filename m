Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452Ab0AJWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0AJWmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428Ab0AJWmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:42:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57980 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0AJWmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:42:10 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Marc Dionne" <marc.c.dionne@gmail.com>,
       "Xiaotian Feng" <dfeng@redhat.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.0FG.xMlSLB@chimera>
Subject: [Bug #15037] BUG during shutdown - bisected to commit e2912009
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15037
Subject		: BUG during shutdown - bisected to commit e2912009
Submitter	: Marc Dionne <marc.c.dionne@gmail.com>
Date		: 2010-01-02 0:27 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=126239207631034&w=4
Handled-By	: Xiaotian Feng <dfeng@redhat.com>
Patch		: http://patchwork.kernel.org/patch/71537/


