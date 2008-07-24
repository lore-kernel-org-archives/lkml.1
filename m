Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYGXL4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYGXL4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYGXL4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:56:07 -0400
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:51343 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYGXL4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:56:06 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48886DD9.7040906@cam.ac.uk>
Date: Thu, 24 Jul 2008 12:56:09 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Eric Piel <eric.piel@tremplin-utc.net>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 1/4] Industrialio Core
References: <488763AD.4050400@gmail.com> <488765A5.3040703@gmail.com> <488844F4.1090809@tremplin-utc.net>
In-Reply-To: <488844F4.1090809@tremplin-utc.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Piel wrote:
> Jonathan Cameron schreef:
> :
>> +
>> +static void __exit iio_exit(void)
>> +{
>> +	unregister_chrdev(IIO_MAJOR, "bob");
> bob?! Maybe you meant "industrialio" ?
> 
> See you,
> Eric
>
Good spot ;)

Jonathan
