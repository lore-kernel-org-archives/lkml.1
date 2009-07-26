Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZGZXSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZGZXSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZGZXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:18:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbZGZXSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:18:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Paul Collins" <paul@burly.ondioline.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.AKE.6HObKB@chimera>
Subject: [Bug #13728] 2.6.31-rc2 soft lockups, RPC-related
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13728
Subject		: 2.6.31-rc2 soft lockups, RPC-related
Submitter	: Paul Collins <paul@burly.ondioline.org>
Date		: 2009-07-05 7:17 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=124677884816794&w=4


