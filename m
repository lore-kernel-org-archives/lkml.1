Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYJ1KCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYJ1KCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYJ1KCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:02:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59649 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751518AbYJ1KCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:02:10 -0400
Date: Tue, 28 Oct 2008 10:02:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Message-ID: <20081028100207.GA7876@rakim.wolfsonmicro.main>
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1225121905-23782-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20081027232212.02626142.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027232212.02626142.akpm@linux-foundation.org>
X-Cookie: Only God can make random selections.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:22:12PM -0700, Andrew Morton wrote:
> On Mon, 27 Oct 2008 15:38:25 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > This driver was originally written by Graeme Gregory and Liam Girdwood,
> > though it has been modified since then to update it to current mainline
> > coding standards and for API completeness.

> Graeme doesn't seem to get a mention anywhere in the driver?

Hrm, yeah.  That should probably read Liam and Graeme rather than the
way it is - AFAICT Graeme's work was bugfixing and updates.

> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> > Updated to use schedule_timeout_uninterruptible() as per Andrew's
> > suggestion.

> You also did this:

Oops, sorry.  I had thought I'd posted a version with those changes in
already.
