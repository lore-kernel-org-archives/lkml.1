Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbYAaXSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbYAaXSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYAaXSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:18:07 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:42641 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752763AbYAaXSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:18:05 -0500
Date: Fri, 1 Feb 2008 08:17:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/KCONFIG] - Add SUPERH depends to sound/soc/sh/Kconfig
Message-ID: <20080131231715.GB16399@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	linux-sh <linux-sh@vger.kernel.org>,
	linux-main <linux-kernel@vger.kernel.org>
References: <20080131225811.a175de2c.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131225811.a175de2c.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 10:58:11PM +0100, Kristoffer Ericson wrote:
> Currently you will see an empty "SoC Audio support for SuperH" menu 
> when building for other archs (example pxa).
> This patch adds "depends on SUPERH" to remove that empty menu.
> 
> signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> 
Yeah, I noticed that too. Please send this to the ALSA folks.
