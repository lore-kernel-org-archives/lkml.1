Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbZDFWAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbZDFWAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759602AbZDFVwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:52:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49962 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760032AbZDFVwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:52:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" Chris Friesen "" <cfriesen@nortel.com>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Michael Ellerman" <michael@ellerman.id.au>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.9HH.zFn2JB@chimera>
Subject: [Bug #13019] /proc/<pid>/maps offset output broken in 2.6.29
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13019
Subject		: /proc/<pid>/maps offset output broken in 2.6.29
Submitter	: "Chris Friesen" <cfriesen@nortel.com>
Date		: 2009-04-01 23:18 (6 days old)
References	: http://marc.info/?l=linuxppc-embedded&m=123862902916059&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>


