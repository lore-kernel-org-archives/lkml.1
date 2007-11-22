Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbXKVUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbXKVUnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 15:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXKVUnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 15:43:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXKVUnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 15:43:03 -0500
Message-ID: <4745E9C2.5040302@anagramm.de>
Date: Thu, 22 Nov 2007 21:42:42 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: devzero@web.de
CC: Simon Arlott <simon@fire.lp0.eu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: System reboot triggered by just reading a device file....!?
References: <1614227@web.de>
In-Reply-To: <1614227@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/TFLCUFha/Qe90rKR4YxQ9pYTgIekFexDHl6S
 3t9/Pzr8rv2ywyE/JfbCsKaw3W/UceLCrvuo5UnUSQRNHwrm+B
 hUav8AiFu2bkXyaQ3BukQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de schrieb:

 > [was: reading /dev/watchdog triggers reboot as intended]
 > need to change my own philosophy now, because i learned that reading isn`t harmless.   ;)

If you want to protect you from your curiosity (or from reading anything),
you could just disable the watchdog in the kernel.
See: Device Drivers -> Character devices -> Watchdog Timer Support -> ...

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
