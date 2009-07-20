Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZGTSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZGTSyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZGTSya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:54:30 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:41932 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZGTSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:54:30 -0400
Date: Mon, 20 Jul 2009 21:54:22 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: balajitk@ti.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Rajendra Nayak <rnayak@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 4/4] ARM: OMAP: Rename twl4030_ to twl_ in
 twl-regulator.c to make it generic reg
Message-ID: <20090720185422.GD7984@gandalf>
Reply-To: me@felipebalbi.com
References: <1248096765-14299-1-git-send-email-balajitk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248096765-14299-1-git-send-email-balajitk@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 07:02:45PM +0530, balajitk@ti.com wrote:
> From: Rajendra Nayak <rnayak@ti.com>
> 
>  This patch renames all twl4030_ functions to twl so that regulator driver
>  can be reused by Triton - TWL4030 and Phoenix - TWL6030.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> Signed-off-by: Balaji T K <balajitk@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

and again.

-- 
balbi
