Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZJKXGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZJKXGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZJKXGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:06:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbZJKXGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:06:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <frodone@gmail.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.btB.Wzl0KB@chimera>
Subject: [Bug #14329] Sata disk doesn't wake up after S3 suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14329
Subject		: Sata disk doesn't wake up after S3 suspend
Submitter	:  <frodone@gmail.com>
Date		: 2009-10-05 22:58 (7 days old)


