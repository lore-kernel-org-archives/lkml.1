Return-Path: <linux-kernel-owner+w=401wt.eu-S1030826AbXAZIqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030826AbXAZIqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 03:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030827AbXAZIqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 03:46:17 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4097 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030826AbXAZIqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 03:46:17 -0500
Date: Fri, 26 Jan 2007 09:46:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH] Add support for OneForAll remote JP1 parallel
 port interface
Message-Id: <20070126094644.805702c6.khali@linux-fr.org>
In-Reply-To: <20070125184139.GV27092@earth.li>
References: <20070125184139.GV27092@earth.li>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Thu, 25 Jan 2007 18:41:39 +0000, Jonathan McDowell wrote:
> This simple patch adds support to i2c-parport for the OneForAll remote
> JP1 parallel port interfaces which can be found detailed at:
> 
> http://www.hifi-remote.com/jp1/hardware.shtml
> 
> These allow access to the internal configuration EEPROM on various
> remote controls and there are a variety of Windows tools that make use
> of this hardware. I have tested this patch with the "simple" parallel
> port device and a OneForAll URC-7562 and confirmed that the data read
> using the eeprom i2c driver matches that returned by the Windows "IR"
> JP1 tool.
> 
> Signed-Off-By: Jonathan McDowell <noodles@earth.li>

Patch applied, thanks.

-- 
Jean Delvare
