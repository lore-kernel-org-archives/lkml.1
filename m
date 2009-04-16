Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbZDQAmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbZDQAmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbZDQAef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:34:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36590 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759620AbZDQAed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:34:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Patrick McHardy" <kaber@trash.net>,
       "Stephen Hemminger" <shemminger@vyatta.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.XWH.Iw85JB@chimera>
Subject: [Bug #13118] iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:06 +0200 (CEST)
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
Date		: 2009-04-10 16:05 (7 days old)
References	: http://lkml.org/lkml/2009/4/10/111
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>


