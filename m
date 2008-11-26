Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYKZIvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYKZIvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYKZIqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:46:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39486
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbYKZIqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:46:10 -0500
Date: Wed, 26 Nov 2008 00:46:09 -0800 (PST)
Message-Id: <20081126.004609.15230324.davem@davemloft.net>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 01/24] perfmon: generic headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <492d0bd6.0f345e0a.167c.3b37@mx.google.com>
References: <492d0bd6.0f345e0a.167c.3b37@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:41:58 -0800 (PST)

> +/*
> + * system adminstrator configuration controls available via
> + * the /sys/kerne/perfmon interface
> + */

This sysfs path typo I pointed out a few hours ago remains :-)
It should be "/sys/kernel/perfmon", the 'l' is missing.


