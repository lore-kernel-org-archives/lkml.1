Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZEXWOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZEXWOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbZEXWJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:09:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759177AbZEXWJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:09:24 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander V. Lukyanov" <lav@yar.ru>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.U8H.a9bGKB@chimera>
Subject: [Bug #13339] rtable leak in ipv4/route.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13339
Subject		: rtable leak in ipv4/route.c
Submitter	: Alexander V. Lukyanov <lav@yar.ru>
Date		: 2009-05-18 14:10 (7 days old)


