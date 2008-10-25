Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYJYXDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYJYXDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbYJYW7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:59:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbYJYW7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:59:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dan Williams" <dcbw@redhat.com>, "Jouni Malinen" <j@w1.fi>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       "Zhu Yi" <yi.zhu@intel.com>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
In-Reply-To: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gLTYxg3cC1.A.pFG.JL6AJB@chimera>
Subject: [Bug #11476] failure to associate after resume from suspend to ram
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 23:07:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11476
Subject		: failure to associate after resume from suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-09-01 13:33 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=122028529415108&w=4
Handled-By	: Zhu Yi <yi.zhu@intel.com>
		  Dan Williams <dcbw@redhat.com>
		  Jouni Malinen <j@w1.fi>


