Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXK0HKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXK0HKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbXK0HKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:10:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbXK0HKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:10:46 -0500
Date: Mon, 26 Nov 2007 23:10:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: Re: [PATCH] dmaengine: Driver for the AVR32 DMACA controller
Message-Id: <20071126231026.058d74f0.akpm@linux-foundation.org>
In-Reply-To: <200711221920.52137.david-b@pacbell.net>
References: <1195558597-23187-1-git-send-email-hskinnemoen@atmel.com>
	<200711221920.52137.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This:

> Subject: Re: [PATCH] dmaengine: Driver for the AVR32 DMACA controller

in no way describes this:

> This patch corrects recently changed (and now invalid) Kconfig
> descriptions for the DMA engine framework:

grr.
