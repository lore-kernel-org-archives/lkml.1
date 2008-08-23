Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYHWTyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYHWTyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYHWTnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:43:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbYHWTnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:43:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Alan Cox" <alan@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Laurent Riffard" <laurent.riffard@free.fr>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.18G.QaGsIB@albercik>
Subject: [Bug #11401] pktcdvd: BUG, NULL pointer dereference in pkt_ioctl, bisected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11401
Subject		: pktcdvd: BUG, NULL pointer dereference in pkt_ioctl, bisected
Submitter	: Laurent Riffard <laurent.riffard@free.fr>
Date		: 2008-08-22 08:16 (2 days old)


