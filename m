Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZDYWXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZDYWXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbZDYWTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:19:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbZDYWTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:19:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Oliver Neukum" <oliver@neukum.org>,
       "Oliver Neukum" <oneukum@linux-d698.sisk.pl (none)>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.YMD.Id48JB@chimera>
Subject: [Bug #13136] possible circular locking dependency detected while suspending laptop to S3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13136
Subject		: possible circular locking dependency detected while suspending laptop to S3
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-04-18 11:17 (8 days old)
Handled-By	: Oliver Neukum <oliver@neukum.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=13136#c1


