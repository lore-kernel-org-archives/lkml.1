Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYAQIhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYAQIhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYAQIhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:37:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47645 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYAQIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:37:06 -0500
Date: Thu, 17 Jan 2008 08:36:38 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org
Subject: Re: [patch 1/3] bug.h: Remove HAVE_ARCH_BUG and HAVE_ARCH_WARN
Message-ID: <20080117083638.GA5959@flint.arm.linux.org.uk>
Mail-Followup-To: Olof Johansson <olof@lixom.net>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org
References: <20080117010130.GA24663@lixom.net> <20080117010827.GA24766@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117010827.GA24766@lixom.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 07:08:27PM -0600, Olof Johansson wrote:
> No need to have the HAVE_ARCH_BUG.* / HAVE_ARCH_WARN.* defines, when
> the generic implementation can just use #ifndef on the macros themselves.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: <linux-arch@vger.kernel.org>

For the ARM bit:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
