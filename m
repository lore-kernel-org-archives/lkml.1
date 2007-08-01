Return-Path: <linux-kernel-owner+w=401wt.eu-S1761656AbXHAHmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761656AbXHAHmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbXHAHmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:42:06 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:46989 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309AbXHAHmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:42:05 -0400
Message-ID: <46B038B5.2030702@gmail.com>
Date: Wed, 01 Aug 2007 09:39:33 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: kriko <kristjan.ugrin@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: Reboot hang FIXED
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site> <46AFABE8.7050107@gmail.com> <op.twcmvlvcatcbto@linux.site> <46AFAF4E.1000605@gmail.com> <op.twcrsx1yatcbto@linux.site>
In-Reply-To: <op.twcrsx1yatcbto@linux.site>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 01:35 AM, kriko wrote:

>> Machine hangs at summary screen where it would be trying a boot from 
>> DVD normally on cold boot, or reboot from Windows. reboot=b doesn't help.
> 
> Sorted out, built 2 kernels, one with old driver, other with only new 
> driver. The one with old driver hangs (it could be because 
> BLK_DEV_OFFBOARD was enabled?),

As far as I'm aware it shouldn't, but ...

> using only new drivers works fine.

... oh well. I suppose it's not really worth it to try and debug that. Cheers.

Rene.
