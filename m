Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZHZAFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZHZAFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbZHZAFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:05:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58983 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbZHZAFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:05:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?J=C3=B6rg=20Sommer?=" <joerg@alea.gnuu.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
In-Reply-To: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Cg6cQYLdUxG.A.rgB.L0GlKB@chimera>
Subject: [Bug #13797] iBook G4 doesn't suspend since 2ed8d2b3a8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 23:05:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13797
Subject		: iBook G4 doesn't suspend since 2ed8d2b3a8
Submitter	: Jörg Sommer <joerg@alea.gnuu.de>
Date		: 2009-07-18 20:18 (39 days old)


