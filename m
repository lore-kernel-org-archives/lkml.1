Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZJAWwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZJAWwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZJAWwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:52:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZJAWuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:50:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
In-Reply-To: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q3xT3CnoTGE.A.OuG.L4SxKB@chimera>
Subject: [Bug #14279] Suspend to RAM freeze totally since 2.6.32-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:38:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14279
Subject		: Suspend to RAM freeze totally since 2.6.32-rc1
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:14 (2 days old)


