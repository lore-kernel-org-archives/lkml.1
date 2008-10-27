Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYJ0KI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYJ0KI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYJ0KIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:08:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55651 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752052AbYJ0KIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:08:48 -0400
Date: Mon, 27 Oct 2008 10:08:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Message-ID: <20081027100845.GA8282@rakim.wolfsonmicro.main>
References: <20081020193328.GA10272@rakim.wolfsonmicro.main> <1224531318-10349-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1224531318-10349-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20081026221431.7100bbf7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026221431.7100bbf7.akpm@linux-foundation.org>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 10:14:31PM -0700, Andrew Morton wrote:

> I'll switch those to schedule_timeout_uninterruptible(), OK?

OK.
