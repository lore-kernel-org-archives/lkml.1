Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbYLDAql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbYLDAql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYLDAot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:44:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48758 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbYLDAop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:44:45 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
In-Reply-To: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TpbYvO5GPt.A.yBG.zKyNJB@chimera>
Subject: [Bug #11215] INFO: possible recursive locking detected ps2_command
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 23:40:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (126 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4


