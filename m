Return-Path: <linux-kernel-owner+w=401wt.eu-S1767271AbXEBTJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767271AbXEBTJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767272AbXEBTJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:09:04 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3862 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767273AbXEBTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:09:01 -0400
Date: Wed, 2 May 2007 20:08:50 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from the LSR and MSR
Message-ID: <20070502190850.GA16696@flint.arm.linux.org.uk>
Mail-Followup-To: Corey Minyard <minyard@acm.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org, Andrew Morton <akpm@osdl.org>
References: <20070502142900.GA22000@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502142900.GA22000@localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 09:29:00AM -0500, Corey Minyard wrote:
> I didn't hear back, so I went ahead and did a patch.

You haven't heard back because I've not had a chance (and still
haven't) to look at the various data sheets I've accumulated.
I'll be catching up with anything not requiring a simple
email reply tomorrow.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
