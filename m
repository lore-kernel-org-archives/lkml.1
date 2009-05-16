Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbZEPXE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbZEPXE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbZEPXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:00:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbZEPXAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:00:16 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "C Sights" <csights@fastmail.fm>, "Dave Airlie" <airlied@redhat.com>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
In-Reply-To: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pQ9WADCjgyE.A.xuG.RA0DKB@chimera>
Subject: [Bug #13144] resume from suspend fails using video card i915
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 22:06:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13144
Subject		: resume from suspend fails using video card i915
Submitter	: C Sights <csights@fastmail.fm>
Date		: 2009-04-21 17:03 (26 days old)


