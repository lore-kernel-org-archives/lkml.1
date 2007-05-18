Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbXERAd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbXERAd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXERAdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:33:52 -0400
Received: from mail.tmr.com ([64.65.253.246]:40647 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbXERAdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:33:51 -0400
Message-ID: <464CF450.20502@tmr.com>
Date: Thu, 17 May 2007 20:33:20 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       Antonino Ingargiola <tritemio@gmail.com>
Subject: Re: [1/2] 2.6.22-rc1: known regressions
References: <46475595.4050105@googlemail.com> <20070514082207.5df59f6e@hyperion.delvare>
In-Reply-To: <20070514082207.5df59f6e@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Michal,
> 
> On Sun, 13 May 2007 20:14:45 +0200, Michal Piotrowski wrote:
>> I2C
>>
>> Subject    : "Sensors Applet" give an error message "No chip detected"
>> References : http://lkml.org/lkml/2007/5/13/109
>> Submitter  : Antonino Ingargiola <tritemio@gmail.com>
>> Status     : Unknown
> 
> There is currently zero proof that this has anything to do with I2C.
> 
I believe in another thread this has been traced to a change in the 
interface and can be solved with an upgrade for the applet.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
