Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZD1DOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZD1DOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZD1DOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:14:35 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:47142 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZD1DOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:14:35 -0400
X-Greylist: delayed 1764 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 23:14:35 EDT
Message-ID: <49F66DB5.7020603@miraclelinux.com>
Date: Tue, 28 Apr 2009 11:45:09 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Fix define values of CS1_HIB_MODE.
References: <492548F3.6090307@miraclelinux.com> <20081120140427.GA27464@rakim.wolfsonmicro.main>
In-Reply-To: <20081120140427.GA27464@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I'm sorry for this late reply.

I checked the WM8350 DATA SHEET Rev 4.0 P287.
It's already corrected.

Thank you for your work.

Regards,
Naohiro Ooiwa


Mark Brown wrote::
> On Thu, Nov 20, 2008 at 08:24:35PM +0900, Naohiro Ooiwa wrote:
> 
>> I found a little mistake.
>> The define values are wrong.
> 
>> It is written in the WM8350 DATA SHEET Rev 3.4 P285 that
>> CS1_HIB_MODE(bit 12) is disable at "1".
> 
> I will double check but I believe this to be a datasheet error - if it
> is it will be corrected in the datasheet.
> 

