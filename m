Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYJDT0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYJDT0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYJDTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:19:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbYJDTTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:19:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "sangu" <sangu.gnome@gmail.com>
References: <0pOgGB.A.uLG.E475IB@wind>
In-Reply-To: <0pOgGB.A.uLG.E475IB@wind>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yWwteD.A.i3G.l475IB@wind>
Subject: [Bug #11643] ALSA sound/core/pcm_native.c:1947: BUG? (err &gt;= 0)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  4 Oct 2008 19:32:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11643
Subject		: ALSA sound/core/pcm_native.c:1947: BUG? (err &gt;= 0)
Submitter	: sangu <sangu.gnome@gmail.com>
Date		: 2008-09-24 16:51 (11 days old)


