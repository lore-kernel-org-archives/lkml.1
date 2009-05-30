Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbZE3Wy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbZE3Wy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbZE3Wxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:53:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46765 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbZE3Wxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:53:50 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jos van der Ende" <seraph@xs4all.nl>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.CSH.sWbIKB@chimera>
Subject: [Bug #12947] r128: system hangs when X is started with DRI enabled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12947
Subject		: r128: system hangs when X is started with DRI enabled
Submitter	: Jos van der Ende <seraph@xs4all.nl>
Date		: 2009-03-26 16:14 (66 days old)


