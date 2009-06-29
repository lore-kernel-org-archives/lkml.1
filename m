Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbZF2Aqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbZF2Aqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbZF2Ahp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:37:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759452AbZF2Ahk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:37:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Etienne Basset" <etienne.basset@numericable.fr>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.RvE.BjASKB@chimera>
Subject: [Bug #13663] suspend to ram regression (IDE related)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:31:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13663
Subject		: suspend to ram regression (IDE related)
Submitter	: Etienne Basset <etienne.basset@numericable.fr>
Date		: 2009-06-26 17:40 (3 days old)
References	: http://lkml.org/lkml/2009/6/26/242
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Patch		: http://patchwork.kernel.org/patch/32719/


