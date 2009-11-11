Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbZKKOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbZKKOXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbZKKOXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:23:48 -0500
Received: from mailgw3.ericsson.se ([193.180.251.60]:47685 "EHLO
	mailgw3.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbZKKOXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:23:47 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2009 09:23:47 EST
X-AuditID: c1b4fb3c-b7b3fae00000105f-4d-4afac572818b
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 0/3] Provide generic function to calc mult/shift factors forclocks
Date: Wed, 11 Nov 2009 15:08:46 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0DCE18A4@eseldmw101.eemea.ericsson.se>
In-Reply-To: <20091111134018.393422332@linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/3] Provide generic function to calc mult/shift factors forclocks
Thread-Index: Acpi2CRXRiqRdgMcQjSihd5GgQSZRQAAD38Q
References: <20091111134018.393422332@linutronix.de>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, "Ralf Baechle" <ralf@linux-mips.org>,
       "John Stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
X-OriginalArrivalTime: 11 Nov 2009 14:08:50.0711 (UTC) FILETIME=[7E6E8270:01CA62D8]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[tglx]
> This patch set provides a generic function which replaces the MIPS
> implementation.

Sweet as pie!

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Linus Walleij
