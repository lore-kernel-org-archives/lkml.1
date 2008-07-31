Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYGaJz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYGaJz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYGaJzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:55:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36714
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752413AbYGaJzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:55:47 -0400
Date: Thu, 31 Jul 2008 02:55:47 -0700 (PDT)
Message-Id: <20080731.025547.35826309.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: torvalds@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
 features not needed on embedded devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217497912.3454.95.camel@pmac.infradead.org>
References: <20080731092703.661994657@free-electrons.com>
	<20080731.024027.162488608.davem@davemloft.net>
	<1217497912.3454.95.camel@pmac.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 31 Jul 2008 10:51:52 +0100

> But there are a lot of people who really don't need these features
> and really want the option of leaving them out.

I'll say it one last time.

If you have ipv4 enabled, you need ETHTOOL.
