Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZAKNeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZAKNeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZAKNdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:33:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36629 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZAKNdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:33:05 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Sandeen" <sandeen@sandeen.net>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
In-Reply-To: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oWTznAnH9BI.A.sF.WHfaJB@chimera>
Subject: [Bug #12402] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:16:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12402
Subject		: 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-01-09 04:41 (3 days old)
References	: http://thread.gmane.org/gmane.comp.file-systems.xfs.general/27548
Handled-By	: Christoph Hellwig <hch@infradead.org>


