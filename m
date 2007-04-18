Return-Path: <linux-kernel-owner+w=401wt.eu-S2992848AbXDRWWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992848AbXDRWWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992855AbXDRWWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:22:52 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:38059 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992848AbXDRWWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:22:52 -0400
Message-ID: <462699F2.3070703@tremplin-utc.net>
Date: Thu, 19 Apr 2007 00:21:38 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wistron_btns: small fix and led support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following two patches are against the input tree and improve the 
wistron_btns driver.
The first patch is mostly trivial, it fixes a typo that I introduced in 
the previous batch.
The second patch adds led support to the driver (and therefore also 
dependency on the led class).

See you,
Eric
