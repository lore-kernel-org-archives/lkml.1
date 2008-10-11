Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYJKOqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYJKOqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYJKOqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:46:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40844 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198AbYJKOqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:46:38 -0400
Date: Sat, 11 Oct 2008 15:46:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] mfd: Add GPIO pin configuration support for
	WM8350
Message-ID: <20081011144636.GA4633@opensource.wolfsonmicro.com>
References: <1223650696-15552-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-5-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-6-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-7-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-8-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-9-git-send-email-broonie@opensource.wolfsonmicro.com> <1223650696-15552-10-git-send-email-broonie@opensource.wolfsonmicro.com> <20081011140950.GB2712@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011140950.GB2712@sortiz.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 04:09:51PM +0200, Samuel Ortiz wrote:
> On Fri, Oct 10, 2008 at 03:58:12PM +0100, Mark Brown wrote:

> > these pins. They can also be used as GPIOs in the normal Linux sense -
> > a subsequent patch will add support for doing so.

> I expect it to implement the giolib interface, right ?

Yes, that's the intention.
