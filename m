Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbYHBThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbYHBThm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbYHBT2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:28:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759350AbYHBT2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:28:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5ZeQ4vXWqRC.A.KvD.BNLlIB@albercik>
Subject: [Bug #11215] INFO: possible recursive locking detected ps2_command
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  2 Aug 2008 20:04:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed
and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4


