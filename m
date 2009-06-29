Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbZF2Ajr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbZF2Ajr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbZF2AgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:36:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38710 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758762AbZF2AgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:36:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Laurent Riffard" <laurent.riffard@free.fr>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.PgG.GkASKB@chimera>
Subject: [Bug #13401] pktcdvd writing is really slow with CFQ scheduler (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:30:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13401
Subject		: pktcdvd writing is really slow with CFQ scheduler (bisected)
Submitter	: Laurent Riffard <laurent.riffard@free.fr>
Date		: 2009-05-28 18:43 (32 days old)


