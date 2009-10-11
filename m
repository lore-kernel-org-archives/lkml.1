Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbZJKW0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbZJKW0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZJKW0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:26:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZJKW0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:26:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Ben Efros" <ben@pc-doctor.com>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <r-4Wjt4coy.A._aD.mal0KB@chimera>
Subject: [Bug #14355] USB serial regression after 2.6.31.1 with Huawei E169 GSM modem
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 00:22:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14355
Subject		: USB serial regression after 2.6.31.1 with Huawei E169 GSM modem
Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date		: 2009-10-10 03:07 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125513456327542&w=4


