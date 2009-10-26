Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZJZTlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZJZTlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZJZTlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:41:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267AbZJZTlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:41:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Bumke" <danielbumke@gmail.com>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
In-Reply-To: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vX3ILojF2dJ.A.NDG.oef5KB@chimera>
Subject: [Bug #14400] disable/enable wlan broken with ath5k
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 20:31:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14400
Subject		: disable/enable wlan broken with ath5k
Submitter	: Daniel Bumke <danielbumke@gmail.com>
Date		: 2009-10-13 12:35 (14 days old)


