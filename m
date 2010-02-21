Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0BUVwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:52:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58767 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0BUVw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:52:28 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, "Tao Ma" <tao.ma@oracle.com>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
In-Reply-To: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ClJsQB_ZlxO.A.E6F.OdagLB@chimera>
Subject: [Bug #15278] lockdep warning for iscsi in 2.6.33-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:30:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15278
Subject		: lockdep warning for iscsi in 2.6.33-rc6
Submitter	: Tao Ma <tao.ma@oracle.com>
Date		: 2010-02-09 6:59 (13 days old)
Message-ID	: <4B7107CF.3060703@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=126569884330200&w=2


