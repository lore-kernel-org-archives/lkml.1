Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYFVTJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYFVTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbYFVTFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbYFVTFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:08 -0400
Cc: "Christian Casteyde" <casteyde.christian@free.fr>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.9nF.yupXIB@albercik>
Subject: [Bug #10821] rt25xx: lock dependency warning, association failure, and kmalloc corruption
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
Subject		: rt25xx: lock dependency warning, association failure, and kmalloc corruption
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 14:30 (25 days old)


