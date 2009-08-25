Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbZHYXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbZHYXgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbZHYXgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:36:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58688 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534AbZHYXgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:36:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
In-Reply-To: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_yaHeGjHEzG.A.iaG.wsGlKB@chimera>
Subject: [Bug #14061] Crash due to buggy flat_phys_pkg_id
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 22:34:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14061
Subject		: Crash due to buggy flat_phys_pkg_id
Submitter	: Ravikiran G Thirumalai <kiran@scalex86.org>
Date		: 2009-08-24 18:26 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125114085701508&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
Patch		: http://patchwork.kernel.org/patch/43806/


