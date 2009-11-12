Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZKLW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZKLW1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbZKLW1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:27:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51244 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZKLW1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:27:47 -0500
Date: Thu, 12 Nov 2009 22:25:41 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Add support for LZO-compressed kernel images
Message-ID: <20091112222541.GA9926@flint.arm.linux.org.uk>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 01:27:54PM +0100, Albin Tonnerre wrote:
> Russell: since I believe your initial concerns regarding the ARM part of the
> patch got fixed, do I have your approval?

I was going to run some tests on it to compare this with the existing
stuff, but I haven't managed to get around to it (due to the platforms
I was going to run the tests on breaking - twice.)

I hope I'll be able to run tests tomorrow/this weekend.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
