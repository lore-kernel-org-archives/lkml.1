Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZDYWWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZDYWWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZDYWSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:18:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbZDYWSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:18:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Patrick McHardy" <kaber@trash.net>,
       "Stephen Hemminger" <shemminger@vyatta.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.wAE.Xd48JB@chimera>
Subject: [Bug #13118] iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13118
Subject		: iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-04-10 16:05 (16 days old)
References	: http://lkml.org/lkml/2009/4/10/111
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>


