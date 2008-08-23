Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYHWT5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYHWT5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYHWTnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:43:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbYHWTni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:43:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.zWG._ZGsIB@albercik>
Subject: [Bug #11407] suspend: unable to handle kernel paging request
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11407
Subject		: suspend: unable to handle kernel paging request
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-08-21 17:28 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121933974928881&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Pekka Enberg <penberg@cs.helsinki.fi>
		  Pavel Machek <pavel@suse.cz>


