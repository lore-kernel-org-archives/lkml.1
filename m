Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZHBWCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZHBWCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZHBWCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:02:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38111 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbZHBWCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:02:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Joerg Platte" <jplatte@naasa.net>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.BmF.KqgdKB@chimera>
Subject: [Bug #13669] Kernel bug with dock driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13669
Subject		: Kernel bug with dock driver
Submitter	: Joerg Platte <jplatte@naasa.net>
Date		: 2009-06-14 21:00 (50 days old)
References	: http://lkml.org/lkml/2009/6/14/216
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


