Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYJDTX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYJDTX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYJDTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:18:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbYJDTSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:18:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andy Wettstein" <ajw1980@gmail.com>
References: <0pOgGB.A.uLG.E475IB@wind>
In-Reply-To: <0pOgGB.A.uLG.E475IB@wind>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yWwteD.A.QVH.9475IB@wind>
Subject: [Bug #11568] spontaneous reboot on resume with 2.6.27
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  4 Oct 2008 19:32:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11568
Subject		: spontaneous reboot on resume with 2.6.27
Submitter	: Andy Wettstein <ajw1980@gmail.com>
Date		: 2008-09-14 20:00 (21 days old)


