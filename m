Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZL2PNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZL2PNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZL2PN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:13:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZL2PNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:13:13 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Carlos Corbacho" <carlos@strangeworlds.co.uk>,
       "=?utf-8?q?Old=C5=99ich=20Jedli=C4=8Dka?=" <oldium.pro@seznam.cz>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.ck.mnhOLB@chimera>
Subject: [Bug #14846] acer-wmi kernel OOPS, cannot create duplicit sysfs name
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:09:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14846
Subject		: acer-wmi kernel OOPS, cannot create duplicit sysfs name
Submitter	: Oldřich Jedlička <oldium.pro@seznam.cz>
Date		: 2009-12-19 23:44 (11 days old)
Handled-By	: Carlos Corbacho <carlos@strangeworlds.co.uk>
Patch		: http://patchwork.kernel.org/patch/69795/


