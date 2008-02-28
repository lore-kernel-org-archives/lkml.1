Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbYB1Tgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbYB1Tgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYB1Tgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:36:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51580 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYB1Tgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:36:32 -0500
Date: Thu, 28 Feb 2008 19:35:59 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: kernel@wantstofly.org, nico@cam.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: eliminate MODULE_PARM() usage
Message-ID: <20080228193558.GA576@flint.arm.linux.org.uk>
References: <20080227121116.bd9ee5aa.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227121116.bd9ee5aa.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 12:11:16PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Convert debug-only (and removed) MODULE_PARM() to module_param().
> Compiles cleanly (with DEBUG=1).

Applied, thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
