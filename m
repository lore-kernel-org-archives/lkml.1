Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZGFX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZGFX5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZGFX40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:56:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbZGFX4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:56:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Sean MacLennan" <smaclennan@pikatech.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.8cF.u0oUKB@chimera>
Subject: [Bug #13650] Problem with alloc_arch_preferred_bootmem() on powerpc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13650
Subject		: Problem with alloc_arch_preferred_bootmem() on powerpc
Submitter	: Sean MacLennan <smaclennan@pikatech.com>
Date		: 2009-06-20 19:48 (17 days old)
References	: http://marc.info/?l=linuxppc-embedded&m=124552732411775&w=4


