Return-Path: <linux-kernel-owner+w=401wt.eu-S1764731AbYCDPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764731AbYCDPlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYCDPlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:41:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45772 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754544AbYCDPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:41:13 -0500
Date: Tue, 4 Mar 2008 15:41:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@mail.ru>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Pete MacKay <linux01@architechnical.net>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: Re: WM97xx touchscreen drivers
Message-ID: <20080304154116.GA20298@rakim.wolfsonmicro.main>
Mail-Followup-To: Dmitry <dbaryshkov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Pete MacKay <linux01@architechnical.net>,
	Ian Molton <spyro@f2s.com>, Vince Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <20080229165029.GB11451@rakim.wolfsonmicro.main> <20080304140251.GA24649@rakim.wolfsonmicro.main> <bc64b4640803040727q39b8aa76j45f3355ec7f6363c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640803040727q39b8aa76j45f3355ec7f6363c@mail.gmail.com>
X-Cookie: Safety Third.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 06:27:33PM +0300, Dmitry wrote:

> The 6th patch seems to be lost somehow. And I don't see it in the
> recent -mm tree.

It reached me via the lists and showed up in the archives:

	http://marc.info/?l=linux-kernel&m=120463956527325&w=2

and it is present in the most recent -mm:

	http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/broken-out/input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch

There was no direct CC to you on that particular patch - perhaps that's
what's missing here?
