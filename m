Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZEULHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZEULHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZEULHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:07:41 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:4351 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZEULHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:07:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A1535FB.9000909@tremplin-utc.net>
Date: Thu, 21 May 2009 13:07:39 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Isaac702 <isaac702@gmail.com>,
       Christian Weidle <slateroni@gmail.com>,
       Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: [PATCH 4/4] lis3: Add three new laptop models
References: <4A151E9F.1080405@tremplin-utc.net> <4A151FFF.70406@tremplin-utc.net> <20090521104952.GB2637@elf.ucw.cz>
In-Reply-To: <20090521104952.GB2637@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 21-05-09 12:49, Pavel Machek schreef:
> On Thu 2009-05-21 11:33:51, Éric Piel wrote:
>> Separate the 6710 and 6715, and set the right axis information for the
>> 6715.
>> Reported-by: Isaac702 <isaac702@gmail.com>
>>
>> Add the 6930.
>> Reported-by: Christian Weidle <slateroni@gmail.com>
>>
>> Add the 2710.
>> Reported-by: Pavel Herrmann <morpheus.ibis@gmail.com>
>>
>> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> Actually, I guess this should go before 2/4 and 3/4, as it is really
> trivial.
Indeed. Actually, it probably also applies cleanly on Linus' tree. So it
could be queued for 2.6.30... but I guess it's getting too late.

Eric

