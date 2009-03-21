Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZCUT1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZCUT1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZCUTTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:19:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51937 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbZCUTTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:19:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Francois Romieu" <romieu@fr.zoreil.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A.rS.mZTxJB@chimera>
Subject: [Bug #12867] 2.6.29-rc7 broke r8169 MAC on Thecus n2100 ARM board
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12867
Subject		: 2.6.29-rc7 broke r8169 MAC on Thecus n2100 ARM board
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-03-09 20:29 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=123663065403760&w=4
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


