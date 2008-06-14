Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYFNVZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYFNVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbYFNVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:19:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbYFNVT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:19:57 -0400
Cc: "Christian Casteyde" <casteyde.christian@free.fr>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.NSE.hJDVIB@albercik>
Subject: [Bug 10821] rt25xx: lock dependency warning, association failure, and kmalloc corruption
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:03 +0200 (CEST)
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
Date		: 2008-05-29 14:30 (17 days old)


