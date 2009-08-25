Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbZHYXgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbZHYXgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbZHYXgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:36:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572AbZHYXgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:36:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dominik Brodowski" <linux@dominikbrodowski.net>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
In-Reply-To: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_yaHeGjHEzG.A.KfG.xsGlKB@chimera>
Subject: [Bug #14060] oops: sysfs_remove_link and i915
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 22:34:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14060
Subject		: oops: sysfs_remove_link and i915
Submitter	: Dominik Brodowski <linux@dominikbrodowski.net>
Date		: 2009-08-22 5:48 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125092139113955&w=4


