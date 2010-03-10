Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0CJI2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:28:40 -0500
Received: from mail.perches.com ([173.55.12.10]:1589 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0CJI2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:28:36 -0500
Subject: Re: [PATCH] get_maintainer: Repair STDIN usage
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <1268194799-16375-1-git-send-email-w.sang@pengutronix.de>
References: <1268194799-16375-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 00:28:34 -0800
Message-ID: <1268209714.1545.243.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 05:19 +0100, Wolfram Sang wrote:
> Commit 22dd5b0cba50a197aaa3bd2790a29ee2e8e4e372 (fix perlcritic warnings) broke
> the ability to handle STDIN because the three argument version of open() cannot
> handle standard IO-streams (which is mentioned in PerlBestPractices, too).
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Joe Perches <joe@perches.com>

Oh well.

Acked-by: Joe Perches <joe@perches.com>


