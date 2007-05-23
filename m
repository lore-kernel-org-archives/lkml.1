Return-Path: <linux-kernel-owner+w=401wt.eu-S1764237AbXEWSKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764237AbXEWSKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbXEWSKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:10:43 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXEWSKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:10:42 -0400
Date: Wed, 23 May 2007 19:10:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Gerb Stralko <gerb.stralko@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM/ARM26 Cleanup, using ARRAY_SIZE
Message-ID: <20070523181034.GC1976@flint.arm.linux.org.uk>
Mail-Followup-To: Gerb Stralko <gerb.stralko@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <75b57c110705231027l4d0aeca5u778cb907dbd7c814@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b57c110705231027l4d0aeca5u778cb907dbd7c814@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 01:27:11PM -0400, Gerb Stralko wrote:
> Use the kernel wide ARRAY_SIZE when determining the array size of a struct.
> 
> Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>

Whitespace damanged patch, probably due to using format=flowed in your
mailer.  Please get a proper mail client. 8)

Also, please note that ARM and ARM26 are two separate architectures
maintained by two separate people.  Please don't confuse them and
merge patches - it's about the same level of evilness as labelling
PPC and i386 as one architecture and expecting PPC folk to take the
lot.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
