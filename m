Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbXBVTSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbXBVTSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXBVTSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:18:50 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:47693 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbXBVTSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:18:49 -0500
Date: Thu, 22 Feb 2007 20:17:46 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Meelis Roos <mroos@linux.ee>
cc: Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata-piix ACPI errors
In-Reply-To: <Pine.SOC.4.64.0702221614540.20840@math>
Message-ID: <Pine.LNX.4.61.0702222017290.7553@yvahk01.tjqt.qr>
References: <Pine.SOC.4.64.0702221525480.20840@math>
 <20070222150641.037f7fbe@lxorguk.ukuu.org.uk> <Pine.SOC.4.64.0702221614540.20840@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 22 2007 17:26, Meelis Roos wrote:
>> Not in those but again note that the cable detection is broken 
>> 
>> > ata2.00: ATAPI, max UDMA/33
>
>It shows UDMA/100 for HDD and UDMA/33 for DVD-ROM. Visual inspection 
>confirms that this is correct - DVD-ROM has 40-pin cable and HDD has 
>80-pin one. So at least the result is not wrong.

But should not it do UDMA/66 then?


Jan
-- 
