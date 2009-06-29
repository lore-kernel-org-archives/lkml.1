Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbZF2Alg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbZF2Alg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbZF2Agb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:36:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758873AbZF2AgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:36:25 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Peter Chubb" <peterc@gelato.unsw.edu.au>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.UCG.0jASKB@chimera>
Subject: [Bug #13472] Oops with minicom and USB serial
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:30:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13472
Subject		: Oops with minicom and USB serial
Submitter	: Peter Chubb <peterc@gelato.unsw.edu.au>
Date		: 2009-06-05 1:37 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=124416901026700&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


