Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXCOXCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXCOXCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXCOXCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:02:10 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:58185 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbXCOXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:02:09 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <66C9B920-25AB-4B62-A3C6-CA54D971793B@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Kconfig style question
Date: Thu, 15 Mar 2007 18:01:17 -0500
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For source lines I've seen both:

source "arch/powerpc/platforms/52xx/Kconfig"

and

source arch/powerpc/platforms/85xx/Kconfig

Is there a preferred style?  Quotes or not?

- k
