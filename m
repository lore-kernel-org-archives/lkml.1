Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbYKQP3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbYKQP3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYKQP3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:29:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56723 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750919AbYKQP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:29:25 -0500
Date: Mon, 17 Nov 2008 15:29:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add WM8350 LED driver
Message-ID: <20081117152923.GA13443@rakim.wolfsonmicro.main>
References: <1226933529-13070-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081117152506.GA29949@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117152506.GA29949@gambetta>
X-Cookie: Whoever dies with the most toys wins.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 04:25:06PM +0100, Frederik Deweerdt wrote:

> I may be missing something but isn't the code doing an off-by-one here
> if pdata->max_uA > 223191 ?

No, you're not missing anything.
