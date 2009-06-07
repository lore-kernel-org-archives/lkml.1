Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZFGMzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZFGMzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbZFGMxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:53:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbZFGMxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:53:43 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rich Ercolani" <rercola@acm.jhu.edu>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.YjH.5Z7KKB@chimera>
Subject: [Bug #13330] nfs4 NULL pointer dereference in _nfs4_do_setlk
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13330
Subject		: nfs4 NULL pointer dereference in _nfs4_do_setlk
Submitter	: Rich Ercolani <rercola@acm.jhu.edu>
Date		: 2009-05-17 04:44 (22 days old)
Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>


