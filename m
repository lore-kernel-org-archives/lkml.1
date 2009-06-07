Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZFGMxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZFGMxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZFGMw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:52:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbZFGMw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:52:57 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Niel Lambrechts" <niel.lambrechts@gmail.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.LR.sa7KKB@chimera>
Subject: [Bug #13180] 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13180
Subject		: 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-04-21 21:35 (48 days old)
References	: http://marc.info/?l=linux-kernel&m=124034980819102&w=4
		  http://lkml.org/lkml/2009/4/27/290


