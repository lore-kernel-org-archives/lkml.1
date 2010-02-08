Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0BHXPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:15:46 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:48822 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752929Ab0BHXPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:15:43 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Q] i2c-taos-evm bus driver
Date: Mon, 8 Feb 2010 18:15:26 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902152F0E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Q] i2c-taos-evm bus driver
Thread-Index: AcqpFJjAmZGRtEdXTkuVL+MOCO7kyA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <khali@linux-fr.org>
X-OriginalArrivalTime: 08 Feb 2010 23:15:28.0336 (UTC) FILETIME=[9A1AAD00:01CAA914]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o18NGOmE027732

Hello all,

Is the i2c-taos-evm bus driver broken?

The Documentation says to use the following to tell the kernel that
the device is on the first serial port:

# inputattach --taos-evm /dev/ttyS0

When I try that I get:

inputattach: invalid mode

I checked the source for inputattach on my system (Debian 5.0) and
--taos-evm is missing.  And I have not been able to locate a newer
version of the user-space utility.

Should this driver be marked broken?

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
