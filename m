Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253Ab0COGyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:54:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:34684 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759721Ab0COGyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:06 -0400
From: <samu.p.onkalo@nokia.com>
To: <akpm@osdl.org>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
       <Eric.Piel@tremplin-utc.net>
Date: Mon, 15 Mar 2010 07:53:21 +0100
Subject: RE: [PATCH V2 0/6] lis3lv02d: click and threshold interrupts
Thread-Topic: [PATCH V2 0/6] lis3lv02d: click and threshold interrupts
Thread-Index: Acq9ORM0AttlAKSuThaNdqeEViBkBQG0dVBg
Message-ID: <62697B07E9803846BC582181BD6FB6B826A7E4B586@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1266318571-31083-1-git-send-email-samu.p.onkalo@nokia.com>
 <4B92662A.4080604@tremplin-utc.net>
In-Reply-To: <4B92662A.4080604@tremplin-utc.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 15 Mar 2010 06:53:25.0057 (UTC) FILETIME=[358D1310:01CAC40C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2F6sHmE009366

>> Samu Onkalo (6):
>>   lis3: Add missing constants for 8bit device
>>   lis3: Separate configuration function for 8 bit device
>>   lis3: Introduce platform data for second ff / wu unit
>>   lis3: Add skeletons for interrupt handlers
>>   lis3: Interrupt handlers for 8bit wakeup and click events
>>   lis3: Setup poll interval limits
>(sorry for the delay, I was on holidays)
>
>Just had a look at the patches and they seem fine, so here is my
>Acked-by: Ã‰ric Piel <eric.piel@tremplin-utc.net>
>
>Andrew, would you mind to pick this series of patches to replace the
>dropped one yesterday?
>

Hi,

This patch set was meant to replace the dropped ones

http://www.spinics.net/lists/kernel/msg998876.html


-Samu


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
