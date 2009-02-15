Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZBOOCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZBOOCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZBOOCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:02:13 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:43468 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbZBOOCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:02:12 -0500
Message-ID: <49981F1B.8040302@f-seidel.de>
Date: Sun, 15 Feb 2009 14:56:43 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, rlove@rlove.org,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] MAINTAINERS: switch hdaps to Frank Seidel
References: <49980A67.7030403@suse.de> <20090215143221.202160ae@hyperion.delvare>
In-Reply-To: <20090215143221.202160ae@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jean Delvare wrote:
> On Sun, 15 Feb 2009 13:28:23 +0100, Frank Seidel wrote:
>>  M:	linux-kernel@vger.kernel.org
> 
> I had never noticed this. Either hdaps is considered a hardware
> monitoring driver and the list should be lm-sensors@lm-sensors.org, or
> it's not and the driver should be moved to a different directory
> (drivers/misc, drivers/mfd, whatever.)

Ok, so i'll change this to lm-sensors and subscribe me there.

>> -W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
>> +W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/
> 
> There doesn't appear to be anything hdaps-specific at this address, so
> it's probably not worth mentioning.

Not yet, but i plan to in the next hours or days. Sadfully i'm just
currently struggling with access to my old kernel.org account.

Thanks,
Frank
