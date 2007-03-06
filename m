Return-Path: <linux-kernel-owner+w=401wt.eu-S965122AbXCFPbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbXCFPbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCFPbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:31:35 -0500
Received: from reserv5.univ-lille1.fr ([193.49.225.19]:40174 "EHLO
	reserv5.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122AbXCFPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:31:34 -0500
Message-ID: <45ED8809.70309@tremplin-utc.net>
Date: Tue, 06 Mar 2007 16:26:01 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070215)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wistron button support for TravelMate 610
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>
In-Reply-To: <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender DNS name whitelisted, not delayed by milter-greylist-2.0.2 (reserv5.univ-lille1.fr [193.49.225.19]); Tue, 06 Mar 2007 16:26:02 +0100 (CET)
X-USTL-MailScanner-Information: Please contact the ISP for more information
X-USTL-MailScanner: Found to be clean
X-USTL-MailScanner-From: eric.piel@tremplin-utc.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

03/06/2007 02:36 PM, Dmitry Torokhov wrote/a écrit:
> Hi Eric,
> 
> I believe we have KEY_WLAN for Wifi, not KEY_XFER. I will fix that up.
Oh! Yes, this sounds better, I used KEY_XFER just for historical reasons 
;-) Thanks


> 
>> I'm sending just this one for now (as I can test it) but if you like it,
>> I would like to try to add all the database of keyboards available in
>> acerhk (that Olaf has written).
> 
> That would be nice. I have one request though - please send patches
> inline instead of attachments, or, if you need to send it as an
> attachment then put patch description and signed-off-by there as well
> so I don't have to reassemble it.
> 
Ok, sorry for the troubles. I'll keep patch and description together 
next time :-)

See you,
Eric
