Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYEKVHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYEKVHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759284AbYEKVBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34108 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbYEKVB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:26 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeff Garzik" <jeff@garzik.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.Sh.ow1JIB@chimera>
Subject: [Bug #10623] k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10623
Subject		: k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
Submitter	: Jeff Garzik <jeff@garzik.org>
Date		: 2008-05-04 07:28 (8 days old)
References	: http://lkml.org/lkml/2008/5/4/78
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


