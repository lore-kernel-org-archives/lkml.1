Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYGGVlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYGGVlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYGGVkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:40:51 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62958 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755724AbYGGVku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:40:50 -0400
Date: Mon, 7 Jul 2008 22:39:56 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
 systems
In-Reply-To: <200807072231.57925.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0807072239170.20615@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
 <200807072003.48228.rjw@sisk.pl> <Pine.LNX.4.55.0807072101070.20615@cliff.in.clinika.pl>
 <200807072231.57925.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Rafael J. Wysocki wrote:

> So I'm going to apply the appended combined patch on top of linux-next and
> retest.

 Wonderful!  Thanks for your patience and cooperation.

  Maciej
