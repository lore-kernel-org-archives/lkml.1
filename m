Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab0CLKFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:05:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37104 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab0CLKFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:05:04 -0500
Date: Fri, 12 Mar 2010 10:04:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: linux-kernel@vger.kernel.org, dinuxbg@gmail.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Add support for Olimex SAM9-L9261 SBC
Message-ID: <20100312100454.GA29306@n2100.arm.linux.org.uk>
References: <20100312105817.4392b594@rechenknecht2k7> <20100312110032.2e57fdce@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312110032.2e57fdce@rechenknecht2k7>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 11:00:32AM +0100, Benjamin Valentin wrote:
> diff -urpN -x CVS linux-2.6.34-rc1/arch/arm/configs/sam9_l9261_defconfig linux-2.6.34-rc1-olimex/arch/arm/configs/sam9_l9261_defconfig
> --- linux-2.6.34-rc1/arch/arm/configs/sam9_l9261_defconfig	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.34-rc1-olimex/arch/arm/configs/sam9_l9261_defconfig	2008-10-28 06:08:46.000000000 +0200
> @@ -0,0 +1,1606 @@

Please think about your reviewers when you send patches - do you think
it's reasonable to expect reviewers to scroll through 1600 lines before
they get to something interesting to read?

Always split defconfig patches into a separate patch.
