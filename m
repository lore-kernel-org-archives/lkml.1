Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0CASJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:09:43 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:57162 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0CASJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:09:41 -0500
Date: Mon, 01 Mar 2010 13:09:22 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Mike Rapoport <mike@compulab.co.il>
Cc: David Brownell <david-b@pacbell.net>,
       Denis Turischev <denis@compulab.co.il>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] gpio: add Intel SCH GPIO controller driver
In-reply-to: <4B84CC0E.5060203@compulab.co.il>
Message-id: <alpine.LFD.2.00.1003011304500.4281@localhost.localdomain>
References: <4B73DAEE.5080400@compulab.co.il> <4B7C0DC3.3060907@compulab.co.il>
 <4B812C21.8000602@compulab.co.il> <201002211112.48527.david-b@pacbell.net>
 <4B84CC0E.5060203@compulab.co.il>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've looked at two x86 drivers in drivers/gpiolib (cs5535 and langwell) and
> there's no treatment of ACPI in either of them. Since SCH is defined by Intel
> as "embedded" product, having a GPIO driver for it seems logical even despite
> problems you mention.

FWIW
I believe that Langwell is used only in products without an ACPI BIOS.

Poulsbo, OTOH, is used in zillions of netbooks running Windows XP.
I don't know what a cs5535 is.

cheers,
Len Brown, Intel Open Source Technology Center

