Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbXFCP0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbXFCP0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 11:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXFCPZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 11:25:58 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53530 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXFCPZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 11:25:57 -0400
Date: Sun, 3 Jun 2007 17:22:49 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Simon Arlott <simon@fire.lp0.eu>
cc: Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 23/36] drivers edac Lindent amd76x driver
In-Reply-To: <4662DB9B.400@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.61.0706031722400.10578@yvahk01.tjqt.qr>
References: <616955.99525.qm@web50111.mail.re2.yahoo.com> <4662DB9B.400@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 3 2007 16:17, Simon Arlott wrote:
>On 03/06/07 16:11, Doug Thompson wrote:
>> Run this driver through Lindent for cleanup purposes
>>  amd76x_edac.c |   54
>>  1 file changed, 25 insertions(+), 29 deletions(-)
>> --- linux-2.6.22-rc1.orig/drivers/edac/amd76x_edac.c
>> +++ linux-2.6.22-rc1/drivers/edac/amd76x_edac.c
>> @@ -86,11 +86,9 @@ struct amd76x_dev_info {
>>  
>>  static const struct amd76x_dev_info amd76x_devs[] = {
>>  	[AMD761] = {
>> -		.ctl_name = "AMD761"
>> -	},
>> +		    .ctl_name = "AMD761"},
>>  	[AMD762] = {
>> -		.ctl_name = "AMD762"
>> -	},
>> +		    .ctl_name = "AMD762"},
>>  };
>>  
>
>You're adding a *lot* of spaces...

scripts/checkpatch.pl to the resuce.


	Jan
-- 
