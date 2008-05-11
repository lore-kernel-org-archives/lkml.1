Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYEKVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYEKVKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbYEKVBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322AbYEKVBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:41 -0400
Cc: "David Miller" <davem@davemloft.net>, "Mikael Pettersson" <mikpe@it.uu.se>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.zDH.6v1JIB@chimera>
Subject: [Bug #10645] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10645
Subject		: 2.6.26-rc1 lost half the RAM on UltraSPARC 5
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-05-07 20:36 (5 days old)
References	: http://lkml.org/lkml/2008/5/7/204
Handled-By	: David Miller <davem@davemloft.net>


