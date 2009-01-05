Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZAEQzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZAEQzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAEQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:55:42 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:53988 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZAEQzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ae/UNFZj4iCg3bvvj8xUAupZ52mpXTD40S6g83MVxILIAkGlFACeQMsv2gZwYNLN12
         eXvWeNdjWuwEpGjvhXRatwGlpe8d39r3lbdhrXA2CsDoHbAu9iRD7ILzUwkL2SDOBiP9
         gS/UuPL+osXRp7kKClMNiyPhplxoAX4t3dtFE=
Message-ID: <91b13c310901050855y7cdee2c2yc8a03c4e1a4ac109@mail.gmail.com>
Date: Tue, 6 Jan 2009 00:55:38 +0800
From: "=?UTF-8?Q?Cheng_Renquan_(=E7=A8=8B=E4=BB=BB=E5=85=A8)?=" 
	<crquan@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: KPROBE linking error (who's the maintainer of kernel/power/) ?
Cc: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Matt Helsley" <matthltc@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@suse.cz>, linux-pm@lists.linux-foundation.org
In-Reply-To: <200901051416.04816.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <91b13c310901042312o44afa166t66b23e8ad10d104f@mail.gmail.com>
	 <200901051416.04816.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n05GtrwM018079

On Mon, Jan 5, 2009 at 9:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:>> Furthermore, there seems no entry for maintainers of "kernel/power/",>> who maintain that subdir please add your name to the MAINTAINERS file?>> I just grab some latest touchers of kernel/power/ and kernel/kprobes.c>> as the recipients here.>> I'm one of the maintainers.
I found that linux-pm@lists.linux-foundation.org by searching youremail in the MAINTAINERS file, in the section of "SUSPEND TO RAM" and"HIBERNATION", both not very apparently related to kernel/power/,maybe my careless, maybe we can improve it?
>> Thanks,> Rafael

-- Cheng Renquan (ç¨‹ä»»å…¨), Shenzhen, ChinaEddie Izzard  - "I grew up in Europe, where the history comes from."ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
