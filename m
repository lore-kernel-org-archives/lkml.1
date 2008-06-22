Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbYFVTRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbYFVTRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYFVTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36312 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbYFVTFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:21 -0400
Cc: "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.deD.HtpXIB@albercik>
Subject: [Bug #10961] 2.6.26-rc: nfsd hangs for a few sec
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10961
Subject		: 2.6.26-rc: nfsd hangs for a few sec
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2008-06-21 12:57 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121405308328004&w=4
		  http://marc.info/?l=linux-kernel&m=121412880115289&w=4
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
		  Mel Gorman <mel@csn.ul.ie>
		  Christoph Lameter <clameter@sgi.com>


