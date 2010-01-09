Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189Ab0AIK66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0AIK66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 05:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159Ab0AIK65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 05:58:57 -0500
Received: from poutre.nerim.net ([62.4.16.124]:57271 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab0AIK64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 05:58:56 -0500
Date: Sat, 9 Jan 2010 11:58:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Olof Johansson <olof@lixom.net>
Cc: Wolfram Sang <w.sang@pengutronix.de>, ben-linux@fluff.org,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] pca953x: Minor include cleanup
Message-ID: <20100109115852.5d0b8740@hyperion.delvare>
In-Reply-To: <20100108213415.GA23113@lixom.net>
References: <20100105201042.GA28367@lixom.net>
	<20100105202158.GB4848@pengutronix.de>
	<20100106121722.6e2598ec@hyperion.delvare>
	<20100108213415.GA23113@lixom.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Fri, 8 Jan 2010 15:34:15 -0600, Olof Johansson wrote:
> Boggle. No GPIO maintianer (nor list) mentioned in MAINTAINERS. I
> don't see any common merge paths in the git log of drivers/gpio either,
> besides akpm.

Correct. Feel free to step in ;)

-- 
Jean Delvare
