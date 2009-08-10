Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbZHJGaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbZHJGaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZHJGaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:30:16 -0400
Received: from compulab.co.il ([67.18.134.219]:55672 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZHJGaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:30:15 -0400
Message-ID: <4A7FBE68.6070704@compulab.co.il>
Date: Mon, 10 Aug 2009 09:30:00 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.21 (X11/20090712)
MIME-Version: 1.0
To: felipe.balbi@nokia.com
CC: Felipe Balbi <me@felipebalbi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: userspace: use sysfs_create_group
References: <1249840885-13498-1-git-send-email-me@felipebalbi.com> <4A7FAE22.80809@compulab.co.il> <20090810060610.GN14802@nokia.com>
In-Reply-To: <20090810060610.GN14802@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Felipe Balbi wrote:
> 
> ================================ CUT HERE =====================================
> 
>>From 5e3502b30b2cbd30946e1240d62905db33716dbd Mon Sep 17 00:00:00 2001
> From: Felipe Balbi <felipe.balbi@nokia.com>
> Date: Mon, 10 Aug 2009 09:05:13 +0300
> Subject: [PATCH] regulator: userspace: use sysfs_create_group
> 
> and avoid introducing our own loops for creating
> several sysfs entries.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---

Acked-by: Mike Rapoport <mike@compulab.co.il>

-- 
Sincerely yours,
Mike.

