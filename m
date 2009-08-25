Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbZHYXhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbZHYXhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932573AbZHYXhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:37:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbZHYXgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:36:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Niel Lambrechts" <niel.lambrechts@gmail.com>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
In-Reply-To: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Cg6cQYLdUxG.A.lUD.C3GlKB@chimera>
Subject: [Bug #13180] 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 22:37:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13180
Subject		: 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-04-21 21:35 (127 days old)
References	: http://marc.info/?l=linux-kernel&m=124034980819102&w=4
		  http://lkml.org/lkml/2009/4/27/290


