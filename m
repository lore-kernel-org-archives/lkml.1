Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbZDFWAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbZDFWAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760015AbZDFVwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:52:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760040AbZDFVv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:51:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "Jeff Layton" <jlayton@redhat.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.YdH.3Fn2JB@chimera>
Subject: [Bug #13016] consistent oops from request_key in 2.6.29
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13016
Subject		: consistent oops from request_key in 2.6.29
Submitter	: Jeff Layton <jlayton@redhat.com>
Date		: 2009-03-31 12:45 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123850360107293&w=4
Handled-By	: David Howells <dhowells@redhat.com>
Patch		: http://marc.info/?l=linux-kernel&m=123852150806814&w=4


