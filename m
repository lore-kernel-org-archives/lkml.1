Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYHSH1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYHSH1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYHSH1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:27:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40044 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYHSH1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:27:33 -0400
Date: Tue, 19 Aug 2008 08:27:15 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/23] arm: use the new byteorder headers
Message-ID: <20080819072715.GB30521@flint.arm.linux.org.uk>
References: <1219106875.17033.55.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219106875.17033.55.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 05:47:55PM -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/arm/include/asm/byteorder.h |   25 +++++++++++--------------
>  1 files changed, 11 insertions(+), 14 deletions(-)

You keep posting this, and it's the only bit I see, but... what about
the other bits that it depends on, which without them, it's impossible
to test this patch with?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
