Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbYCDP16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbYCDP16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbYCDP1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:27:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:8882 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761553AbYCDP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N3cbgX/p+5FQVr5Jb81ruZL1NRTkfkVY+ivyP9EcLDj38WBgy7u5uM/Xwr4GPYEBCDC9ie0g5CKjtHxVIjwZx7bKXi0sIWUWmWqpqhwebz0Lqitc7q7dQW6YIWpTzjnhLL6XLRzjBLw/j7e5pBy6dPz6/u9oogidwnO8QxXmq50=
Message-ID: <bc64b4640803040727q39b8aa76j45f3355ec7f6363c@mail.gmail.com>
Date: Tue, 4 Mar 2008 18:27:33 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dmitry Torokhov" <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Hans-Christian Egtvedt" <hcegtvedt@atmel.com>,
       "Liam Girdwood" <liam.girdwood@wolfsonmicro.com>,
       "Graeme Gregory" <gg@opensource.wolfsonmicro.com>,
       "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "Rodolfo Giometti" <giometti@enneenne.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Marc Kleine-Budde" <mkl@pengutronix.de>,
       "Pete MacKay" <linux01@architechnical.net>,
       "Ian Molton" <spyro@f2s.com>, "Vince Sanders" <vince@kyllikki.org>,
       "Andrew Zabolotny" <zap@homelink.ru>
Subject: Re: WM97xx touchscreen drivers
In-Reply-To: <20080304140251.GA24649@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080229165029.GB11451@rakim.wolfsonmicro.main>
	 <20080304140251.GA24649@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/4, Mark Brown <broonie@opensource.wolfsonmicro.com>:
> This patch series adds support for the touchscreen controllers found in
>  WM97xx devices.  This revision of the series adds support for
>  configuration of the interrupt source used for pen down detection in
>  accelerated touch drivers.
>
>  These changes are also available in the git repository at:
>
>
>   git://opensource.wolfsonmicro.com/linux-2.6-touch upstream
>
>  Mark Brown (6):
>       Core driver for WM97xx touchscreens
>       Add chip driver for WM9705 touchscreen
>       Add chip driver for WM9712 touchscreen
>       Add chip driver for WM9713 touchscreen
>       Driver for WM97xx touchscreens in streaming mode on Mainstone
>       Build system and MAINTAINERS entry for WM97xx touchscreen drivers

The 6th patch seems to be lost somehow. And I don't see it in the
recent -mm tree.

-- 
With best wishes
Dmitry
