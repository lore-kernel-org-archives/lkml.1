Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbYILU71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbYILU71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbYILUqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:46:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758404AbYILUqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:46:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Abdel Benamrouche" <draconux@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.oyF.sbsyIB@albercik>
Subject: [Bug #11554] Partition check considered as error is breaking mounting in 2.6.27
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11554
Subject		: Partition check considered as error is breaking mounting in 2.6.27
Submitter	: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date		: 2008-09-12 16:56 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122123862519434&w=4


