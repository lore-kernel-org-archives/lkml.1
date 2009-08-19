Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZHSX2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZHSX2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZHSXY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:24:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbZHSXYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:24:50 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <jsbronder@gentoo.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
In-Reply-To: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ADSuNT6McuD.A.QBB.GOIjKB@chimera>
Subject: [Bug #13914] e1000e reports invalid NVM Checksum on 82566DM-2 (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:26:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13914
Subject		: e1000e reports invalid NVM Checksum on 82566DM-2 (bisected)
Submitter	:  <jsbronder@gentoo.org>
Date		: 2009-08-04 18:06 (16 days old)


