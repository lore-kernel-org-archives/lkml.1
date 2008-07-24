Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYGXJeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYGXJeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYGXJeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:34:11 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:15870 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYGXJeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:34:10 -0400
X-Greylist: delayed 1922 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 05:34:10 EDT
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <488844F4.1090809@tremplin-utc.net>
Date: Thu, 24 Jul 2008 11:01:40 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>, hmh@hmh.eng.br,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 1/4] Industrialio Core
References: <488763AD.4050400@gmail.com> <488765A5.3040703@gmail.com>
In-Reply-To: <488765A5.3040703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron schreef:
:
> +
> +static void __exit iio_exit(void)
> +{
> +	unregister_chrdev(IIO_MAJOR, "bob");
bob?! Maybe you meant "industrialio" ?

See you,
Eric
