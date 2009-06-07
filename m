Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZFGNKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZFGNKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbZFGNHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:07:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58591 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975AbZFGNHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:07:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Martin Knoblauch" <spamtrap@knobisoft.de>,
       "Stephen Hemminger" <shemminger@vyatta.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
In-Reply-To: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AN6kEAA5GQ.A.ktB.Gk7KKB@chimera>
Subject: [Bug #13178] Booting very slow
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 12:06:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13178
Subject		: Booting very slow
Submitter	: Martin Knoblauch <spamtrap@knobisoft.de>
Date		: 2009-04-24 12:45 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=124057716231773&w=4


