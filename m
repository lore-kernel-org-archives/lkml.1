Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYGRXhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYGRXhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYGRXhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:37:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067AbYGRXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:37:05 -0400
Date: Fri, 18 Jul 2008 16:36:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, gregkh@suse.de,
       lethal@linux-sh.org, i2c@lm-sensors.org, magnus.damm@gmail.com
Subject: Re: [PATCH 05/05] sh: add IORESOURCE_CLK to SuperH Mobile I2C
 platform data
Message-Id: <20080718163609.4eaa2d2d.akpm@linux-foundation.org>
In-Reply-To: <20080718074044.32713.83039.sendpatchset@rx1.opensource.se>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
	<20080718074044.32713.83039.sendpatchset@rx1.opensource.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 16:40:44 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> This patch passes processor specific IORESOURCE_CLK information to the
> i2c-sh_mobile driver. With this change the clock to the IIC block will
> be disabled while the I2C bus is inactive. Without this patch the clock
> is always on.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Applies to 6b4b0121a22649640e997b17dd00bb40e97e254d of sh-2.6 git

I can't get this to even vaguely apply to linux-next from 20 minutes ago.
