Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbZEPWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbZEPWP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbZEPWOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:14:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbZEPWOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:14:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Sam Ravnborg" <sam@ravnborg.org>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.vUC.tZzDKB@chimera>
Subject: [Bug #13119] Trouble with make-install from a NFS mount
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13119
Subject		: Trouble with make-install from a NFS mount
Submitter	: Gregory Haskins <ghaskins@novell.com>
Date		: 2009-04-14 21:32 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=123974482327044&w=4
Handled-By	: H. Peter Anvin <hpa@zytor.com>


