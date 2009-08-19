Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZHSX1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZHSX1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZHSX1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:27:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbZHSXZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:25:07 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ralf Hildebrandt" <ralf.hildebrandt@charite.de>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
In-Reply-To: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ADSuNT6McuD.A.68H.vNIjKB@chimera>
Subject: [Bug #14002] WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct+0x164/0x1c0()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:27:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14002
Subject		: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct+0x164/0x1c0()
Submitter	: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Date		: 2009-08-18 12:37 (2 days old)


