Return-Path: <linux-kernel-owner+w=401wt.eu-S1761583AbXGWPyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbXGWPyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXGWPyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:54:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:37029 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbXGWPyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:54:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,571,1175497200"; 
   d="scan'208";a="108960860"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Linus 2.6.23-rc1
Date: Mon, 23 Jul 2007 08:54:27 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01FA5244@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070723154754.GG10653@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linus 2.6.23-rc1
Thread-Index: AcfNQN3QbTQmTPFJQEiUrgWxNjNZmQAAGhIg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Bob Picco" <bob.picco@hp.com>, "Gabriel C" <nix.or.die@googlemail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2007 15:54:29.0484 (UTC) FILETIME=[C0D102C0:01C7CD41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry about that. I thought my review had caught all of these.

I missed it too (my old gcc version 3.4.6 doesn't pop a warning
for this).

Presumably the same change is needed for clocksource_itc in
arch/ia64/kernel/time.c

-Tony

