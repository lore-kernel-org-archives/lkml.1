Return-Path: <linux-kernel-owner+w=401wt.eu-S965717AbXCSHhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717AbXCSHhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 03:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965751AbXCSHhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 03:37:06 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:59623 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965717AbXCSHhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 03:37:04 -0400
Message-ID: <45FE3D4B.20603@boichat.ch>
Date: Mon, 19 Mar 2007 15:35:39 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rlove@rlove.org,
       linux-kernel@hansmi.ch
Subject: Re: [PATCH] Apple SMC driver (hardware monitoring and control)
References: <45F7C083.7090504@boichat.ch>	<45FE1D44.8000805@boichat.ch> <20070318225430.3d704289.akpm@linux-foundation.org>
In-Reply-To: <20070318225430.3d704289.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.204.228 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 19 Mar 2007 13:19:00 +0800 Nicolas Boichat <nicolas@boichat.ch> wrote:
> 
>> This driver provides support for the Apple System Management Controller, which
>> provides an accelerometer (Apple Sudden Motion Sensor), light sensors,
>> temperature sensors, keyboard backlight control and fan control. Only
>> Intel-based Apple's computers are supported (MacBook Pro, MacBook, MacMini).
>>
> 
> It's trivia time:
> [snip]

Thanks for your comments, I'll send a new patch ASAP.

Best regards,

Nicolas
